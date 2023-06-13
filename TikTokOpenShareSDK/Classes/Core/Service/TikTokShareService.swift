/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import TikTokOpenSDKCore

@objc (TTKSDKShareService)
class TikTokShareService: NSObject, TikTokRequestResponseHandling {
    private(set) var completion: ((TikTokBaseResponse) -> Void)?
    private(set) var redirectURI: String?
    
    //MARK: - TikTokRequestHandling
    static func buildOpenURL(from request: TikTokBaseRequest) -> URL? {
        let base = "\(TikTokInfo.universalLink)\(TikTokInfo.universalLinkSharePath)"
        guard var urlComps = URLComponents(string: base) else {
            return nil
        }
        urlComps.queryItems = buildOpenURLQueryParams(from: request)
        return urlComps.url
    }
    
    func handleRequest(_ request: TikTokBaseRequest, completion: ((TikTokBaseResponse) -> Void)?) -> Bool {
        guard let url = Self.buildOpenURL(from: request) else {
            return false
        }
        self.completion = completion
        self.redirectURI = request.redirectURI
        if !TikTokUtils.TikTokIsInstalled() {
            if let tiktokNotInstalledURL = self.constructErrorURL(errorCode: "-1", errorDescription: "TikTok is not installed") {
                self.handleResponseURL(url: tiktokNotInstalledURL)
            }
            return false
        }
        UIApplication.shared.open(url, options: [:]) { [weak self] success in
            guard let self = self else { return }
            if !success, let cancelURL = self.constructErrorURL(errorCode: "-2", errorDescription: "User cancelled share") {
                self.handleResponseURL(url: cancelURL)
            }
        }
        return true
    }
    
    // MARK: - TikTokResponseHandling
    @discardableResult
    func handleResponseURL(url: URL) -> Bool {
        guard let res = try? TikTokShareResponse(fromURL: url, redirectURI: self.redirectURI ?? "") else { return false }
        return handleResponse(res)
    }
    
    @discardableResult
    func handleResponse(_ response: TikTokShareResponse) -> Bool {
        guard let closure = completion else { return false }
        closure(response)
        return true
    }

    // MARK: - Private
    private static func buildOpenURLQueryParams(from request: TikTokBaseRequest) -> [URLQueryItem]? {
        guard let req = request as? TikTokShareRequest else {
            return nil
        }
        
        var queryParams = req.convertToQueryParams()
        if let urlScheme = req.customConfig?.callerUrlScheme {
            queryParams.append(URLQueryItem(name: "callback_url_scheme", value: urlScheme))
        }
        if let _ = req.state {
            queryParams.append(URLQueryItem(name: "state", value: req.state!))
        }
        return queryParams
    }
    
    //MARK: - Construct error URL
    private func constructErrorURL(errorCode: String, errorDescription: String) -> URL? {
        guard let redirectURI = self.redirectURI else { return nil }
        guard let url = URL(string: redirectURI) else { return nil }
        guard var urlComps = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        urlComps.queryItems = [
            URLQueryItem(name: "error_code", value: errorCode),
            URLQueryItem(name: "error_description", value: errorDescription),
            URLQueryItem(name: "from_platform", value: TikTokInfo.shareScheme)
        ]
        return urlComps.url
    }
}
