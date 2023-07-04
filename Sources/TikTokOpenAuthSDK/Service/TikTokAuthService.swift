/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit
import TikTokOpenSDKCore

@objc (TTKSDKAuthService)
class TikTokAuthService: NSObject, TikTokRequestResponseHandling {
    private(set) var completion: ((TikTokBaseResponse) -> Void)?
    private(set) var redirectURI: String?
    
    //MARK: - TikTokRequestHandling
    func handleRequest(
        _ request: TikTokBaseRequest,
        completion: ((TikTokBaseResponse) -> Void)?
    ) -> Bool
    {
        guard let authReq = request as? TikTokAuthRequest else { return false }
        guard let openURL = TikTokAuthService.buildOpenURL(from: authReq) else { return false }
        self.completion = completion
        self.redirectURI = authReq.redirectURI
        UIApplication.shared.open(openURL, options: [:]) { [weak self] success in
            guard let self = self else { return }
            if !success, let cancelURL = self.constructCancelURL() {
                self.handleResponseURL(url: cancelURL)
            }
        }
        return true
    }
    
    static func buildOpenURL(from req: TikTokBaseRequest) -> URL?{
        guard let authReq = req as? TikTokAuthRequest else {
            return nil
        }
        let base = "\(TikTokInfo.universalLink)\(TikTokInfo.universalLinkAuthPath)"
        guard var urlComps = URLComponents(string: base) else {
            return nil
        }
        urlComps.queryItems = authReq.convertToQueryParams()
        return urlComps.url
    }
    
    //MARK: - TikTokResponseHandling
    @discardableResult
    func handleResponseURL(url: URL) -> Bool {
        guard let res = try? TikTokAuthResponse(fromURL: url, redirectURI: self.redirectURI ?? "") else { return false }
        return handleResponse(res)
    }
    
    @discardableResult
    func handleResponse(_ response: TikTokAuthResponse) -> Bool {
        guard let closure = completion else { return false }
        closure(response)
        return true
    }

    //MARK: - Internal
    func handlerRequestViaWeb(
        _ request: TikTokAuthRequest,
        completion: ((TikTokBaseResponse) -> Void)?
    ) -> Bool {
        guard let url = Self.formWebAuthURL(fromRequest: request) else { return false }
        self.completion = completion
        self.redirectURI = request.redirectURI
        UIApplication.shared.open(url, options: [:]) { [weak self] success in
            guard let self = self else { return }
            if !success, let cancelURL = self.constructCancelURL() {
                self.handleResponseURL(url: cancelURL)
            }
        }
        return true
    }
    
    private static func formWebAuthURL(fromRequest authReq: TikTokAuthRequest) -> URL? {
        guard let url = URL(string: TikTokInfo.webAuthIndexURL) else { return nil }
        guard var comps = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        comps.queryItems = authReq.convertToWebQueryParams()
        return comps.url
    }
    
    //MARK: - Construct cancel URL
    private func constructCancelURL() -> URL? {
        guard let redirectURI = self.redirectURI else { return nil }
        guard let url = URL(string: redirectURI) else { return nil }
        guard var urlComps = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        urlComps.queryItems = [
            URLQueryItem(name: "error_code", value: "-2"),
            URLQueryItem(name: "error", value: "access_denied"),
            URLQueryItem(name: "error_string", value: NSLocalizedString("User cancelled authorization", bundle: .module, comment: "")),
        ]
        return urlComps.url
    }
}
