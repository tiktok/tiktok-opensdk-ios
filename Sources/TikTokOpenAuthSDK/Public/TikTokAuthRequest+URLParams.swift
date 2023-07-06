/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import TikTokOpenSDKCore

extension TikTokAuthRequest: TikTokURLQueryParamsConvertible {
    
    //MARK: - TikTokURLQueryParamsConvertible
    public func convertToQueryParams() -> [URLQueryItem] {
        return [
            URLQueryItem(name: "request_id", value: self.requestID),
            URLQueryItem(name: "api_version", value: TikTokInfo.currentVersion),
            URLQueryItem(name: "consumer_key", value: TikTokInfo.clientKey),
            URLQueryItem(name: "app_identity", value: TikTokInfo.sha512BundleId),
            URLQueryItem(name: "device_platform", value: TikTokInfo.device),
            URLQueryItem(name: "state", value: self.state),
            URLQueryItem(name: "permissions", value: self.scopes.joined(separator: ",")),
            URLQueryItem(name: "code_challenge", value: self.pkce.codeChallenge),
            URLQueryItem(name: "redirect_uri", value: self.redirectURI ?? ""),
            URLQueryItem(name: "sdk_name", value: TikTokInfo.authSDKName),
            URLQueryItem(name: "client_key", value: TikTokInfo.clientKey),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: self.scopes.joined(separator: ",")),
            URLQueryItem(name: "use_spark", value: "1"),
            URLQueryItem(name: "hide_nav_bar", value: "1")
        ]
    }
    
    public func convertToWebQueryParams() -> [URLQueryItem] {
        return [
            URLQueryItem(name: "request_id", value: self.requestID),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: self.scopes.joined(separator: ",")),
            URLQueryItem(name: "app_identity", value: TikTokInfo.sha512BundleId),
            URLQueryItem(name: "device_platform", value: TikTokInfo.device),
            URLQueryItem(name: "client_key", value: TikTokInfo.clientKey),
            URLQueryItem(name: "state", value: self.state),
            URLQueryItem(name: "redirect_uri", value: self.redirectURI ?? ""),
            URLQueryItem(name: "code_challenge", value: self.pkce.codeChallenge),
            URLQueryItem(name: "sdk_name", value: TikTokInfo.authSDKName),
        ]
    }
    
}
