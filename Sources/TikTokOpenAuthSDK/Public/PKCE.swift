/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import CryptoKit
import CommonCrypto

@objc (TTKSDKCodeVerifier)
public final class PKCE: NSObject {
    
    public let codeVerifier: String = PKCE.generateCodeVerifier()
    
    public var codeChallenge: String {
        if let data = codeVerifier.data(using: String.Encoding.utf8) {
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            data.withUnsafeBytes {
                _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &digest)
            }
            let hexBytes = digest.map { String(format: "%02hhx", $0) }
            return hexBytes.joined()
        }
        return ""
    }
    
    public static func generateCodeVerifier() -> String {
        let codeVerifierLength = 43
        let validCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._"
        var codeVerifier = ""
        for _ in 0..<codeVerifierLength {
            if let randomCharacter = validCharacters.randomElement() {
                codeVerifier.append(randomCharacter)
            }
        }
        return codeVerifier
    }
    
}
