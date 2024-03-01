/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit
import TikTokOpenSDKCore
import AuthenticationServices

@objc (TTKSDKAuthService)
class TikTokAuthService: NSObject, TikTokRequestResponseHandling {
    private(set) var completion: ((TikTokBaseResponse) -> Void)?
    private(set) var authSession: ASWebAuthenticationSession?
    private(set) var redirectURI: String?
    private(set) var isWebAuth: Bool = false
    private let urlOpener: TikTokURLOpener

    init(urlOpener: TikTokURLOpener = UIApplication.shared) {
        self.urlOpener = urlOpener
    }
    
    //MARK: - TikTokRequestHandling
    func handleRequest(
        _ request: TikTokBaseRequest,
        completion: ((TikTokBaseResponse) -> Void)?
    ) -> Bool
    {
        guard let authReq = request as? TikTokAuthRequest else { return false }
        self.completion = completion
        redirectURI = authReq.redirectURI
        isWebAuth = !urlOpener.isTikTokInstalled() || authReq.isWebAuth
        if isWebAuth {
            return handleRequestViaWeb(request)
        } else {
            guard let url = buildOpenURL(from: authReq) else { return false }
            urlOpener.open(url, options: [:]) { [weak self] success in
                guard let self = self else { return }
                if !success, let cancelURL = self.constructCancelURL(baseURL: authReq.redirectURI ?? "") {
                    self.handleResponseURL(url: cancelURL)
                }
            }
            return true
        }
    }
    
    private func handleRequestViaWeb(
        _ request: TikTokBaseRequest
    ) -> Bool {
        guard let authReq = request as? TikTokAuthRequest else { return false }
        guard let url = buildOpenURL(from: authReq) else { return false }
        let authSession = ASWebAuthenticationSession(url: url, callbackURLScheme: TikTokInfo.clientKey) { [weak self] (callbackURL, error) in
            guard let self = self else { return }
            self.handleWebAuthCallback(callbackURL: callbackURL, error: error as NSError?)
            self.authSession = nil
        }
        if #available(iOS 13.0, *) {
            authSession.presentationContextProvider = self
        }
        authSession.start()
        self.authSession = authSession
        return true
    }

    func buildOpenURL(from req: TikTokBaseRequest) -> URL? {
        guard let authReq = req as? TikTokAuthRequest else { return nil }
        guard let webBaseURL = URL(string: TikTokInfo.webAuthIndexURL) else { return nil }
        guard let nativeBaseURL = URL(string: "\(TikTokInfo.universalLink)\(TikTokInfo.universalLinkAuthPath)") else { return nil }
        let isWebAuth = authReq.isWebAuth || !urlOpener.isTikTokInstalled()
        let baseURL = isWebAuth ? webBaseURL : nativeBaseURL
        guard var urlComps = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else { return nil }
        urlComps.queryItems = isWebAuth ? authReq.convertToWebQueryParams() : authReq.convertToQueryParams()
        return urlComps.url
    }

    //MARK: - TikTokResponseHandling
    @discardableResult
    func handleResponseURL(url: URL) -> Bool {
        guard let res = try? TikTokAuthResponse(fromURL: url, redirectURI: redirectURI ?? "", fromWeb: isWebAuth) else { return false }
        return handleResponse(res)
    }

    @discardableResult
    func handleResponse(_ response: TikTokAuthResponse) -> Bool {
        guard let closure = completion else { return false }
        closure(response)
        return true
    }
    
    private func handleWebAuthCallback(callbackURL: URL?, error: NSError?) {
        if let callbackURL = callbackURL {
            self.handleResponseURL(url: callbackURL)
        } else if let error = error, error.code == 1 {
            guard let cancelURL = self.constructCancelURL(baseURL: TikTokInfo.webAuthRedirectURI) else { return }
            self.handleResponseURL(url: cancelURL)
        } else {
            guard let errorURL = self.constructErrorURL(baseURL: TikTokInfo.webAuthRedirectURI, error: error) else { return }
            self.handleResponseURL(url: errorURL)
        }
    }
    
    private func constructCancelURL(baseURL: String) -> URL? {
        guard let url = URL(string: baseURL) else { return nil }
        guard var urlComps = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        urlComps.queryItems = [
            URLQueryItem(name: "error_code", value: "\(TikTokAuthResponseErrorCode.cancelled.rawValue)"),
            URLQueryItem(name: "error", value: "access_denied"),
            URLQueryItem(name: "error_description", value: "User cancelled authorization"),
        ]
        return urlComps.url
    }
    
    private func constructErrorURL(baseURL: String, error: NSError?) -> URL? {
        guard let url = URL(string: baseURL) else { return nil }
        guard var urlComps = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        urlComps.queryItems = [
            URLQueryItem(name: "error_code", value: "\(TikTokAuthResponseErrorCode.webviewError.rawValue)"),
            URLQueryItem(name: "error", value: "access_denied"),
            URLQueryItem(name: "error_description", value: error?.localizedDescription ?? "Something went wrong")
        ]
        return urlComps.url
    }
}

@available(iOS 13, *)
extension TikTokAuthService: ASWebAuthenticationPresentationContextProviding {
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        UIApplication.shared.keyWindow ?? ASPresentationAnchor()
    }
}
