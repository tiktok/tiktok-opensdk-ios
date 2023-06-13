/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import TikTokOpenSDKCore

extension TikTokShareRequest: TikTokURLQueryParamsConvertible {
    
    //MARK: - TikTokURLQueryParamsConvertible
    public func convertToQueryParams() -> [URLQueryItem] {
        return [
            URLQueryItem(name: "request_id", value: self.requestID),
            URLQueryItem(name: "key", value: self.customConfig?.clientKey ?? TikTokInfo.clientKey),
            URLQueryItem(name: "share_format", value: String(self.shareFormat.rawValue)),
            URLQueryItem(name: "api_version", value: TikTokInfo.currentVersion),
            URLQueryItem(name: "third_app_version", value: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""),
            URLQueryItem(name: "media_type", value: String(self.mediaType.rawValue)),
            URLQueryItem(name: "media_paths", value: self.localIdentifiers?.joined(separator: ",") ?? ""),
            URLQueryItem(name: "bundle_id", value: TikTokInfo.sha512BundleId),
            URLQueryItem(name: "sdk_name", value: TikTokInfo.shareSDKName),
            URLQueryItem(name: "redirect_uri", value: self.redirectURI ?? ""),
        ]
    }
    
}
