/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit

public struct TikTokAppStoreModel {
    private static let tiktokTCountryCodes: [String] = ["JP","KR","MO","KH","ID","LA","MY","MM","PH","TW","TH","VN","NP","LK","BD","PK","SG"]
    
    public let appStoreId: Int
    public let tiktokAppId: Int
    public let baseOnelink: String
    
    public static var M: TikTokAppStoreModel {
        TikTokAppStoreModel.init(appStoreId: 835599320,
                                 tiktokAppId: 1233,
                                 baseOnelink: "https://snssdk1233.onelink.me/bIdt/ikk538qj")
    }
    public static var T: TikTokAppStoreModel {
        TikTokAppStoreModel.init(appStoreId: 1235601864,
                                 tiktokAppId: 1180,
                                 baseOnelink: "https://snssdk1180.onelink.me/BAuo/4az84vxo")
    }
    public static func get() -> TikTokAppStoreModel {
        if (tiktokTCountryCodes.contains(countryCode ?? "")) {
            return .T
        } else {
            return .M
        }
    }
    
    static var countryCode: String? {
        let locale = NSLocale.current as NSLocale
        return locale.object(forKey: .countryCode) as? String
    }
    
    var mediaSource: String {
        return "open_platform_sharekit_\(tiktokAppId)"
    }
    
    public func onelink(clientKey: String) -> String? {
        guard let baseUrl = URL.init(string: baseOnelink) else { return nil }
        guard var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false) else { return nil }
        components.queryItems = [
            URLQueryItem(name: "pid", value: mediaSource),
            URLQueryItem(name: "c", value: clientKey),
            URLQueryItem(name: "is_retargeting", value: "true"),
        ]
        
        return components.url?.absoluteString
    }
}
