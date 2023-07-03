/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit
import var CommonCrypto.CC_SHA512_DIGEST_LENGTH
import func CommonCrypto.CC_SHA512
import typealias CommonCrypto.CC_LONG

@objc (TTKSDKInfo)
public class TikTokInfo: NSObject {
    public static private(set) var currentVersion = "2.0.0"
    public static private(set) var universalLink = "https://www.tiktok.com"
    public static private(set) var universalLinkAuthPath = "/opensdk/oauth/"
    public static private(set) var universalLinkSharePath = "/opensdk/share/"
    public static private(set) var authSDKName = "tiktok_sdk_auth"
    public static private(set) var shareSDKName = "tiktok_sdk_share"
    public static private(set) var shareScheme = "tiktoksharesdk"
    
    public static let schemes = ["snssdk1233", "snssdk1180"]
    public static let webAuthIndexURL = "https://www.tiktok.com/v2/auth/authorize/"

    public static var clientKey: String {
        return Bundle.main.infoDictionary?["TikTokClientKey"] as? String ?? ""
    }

    public static let device: String = {
        let idiom = UIDevice.current.userInterfaceIdiom
        return idiom == .pad ? "ipad" : "iphone"
    }()
    
    public static var sha512BundleId: String {
        func SHA512(string: String) -> Data {
            let length = Int(CC_SHA512_DIGEST_LENGTH)
            let messageData = string.data(using:.utf8)!
            var digestData = Data(count: length)
            _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
                messageData.withUnsafeBytes { messageBytes -> UInt8 in
                    if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                        let messageLength = CC_LONG(messageData.count)
                        CC_SHA512(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                    }
                    return 0
                }
            }
            return digestData
        }
        let sha512Data = SHA512(string: Bundle.main.bundleIdentifier ?? "")
        return sha512Data.map { String(format: "%02hhx", $0) }.joined()
    }
}
