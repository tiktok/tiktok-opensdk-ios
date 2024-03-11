/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation


@objc (TTKSDKRSA)
class TikTokRSA: NSObject{
    
    static func encrypt(_ data: Data, withPublicKeyString keyStr: String) -> Data? {
        guard let key = add(publicKeyString: keyStr) else {
            return nil
        }
        return encrypt(data, withPublicKey: key)
    }
    
    static func encrypt(_ data: Data, withPublicKey key: SecKey)-> Data? {
        if #available(iOS 10, *) {
            let algo: SecKeyAlgorithm = .rsaEncryptionPKCS1
            guard SecKeyIsAlgorithmSupported(key, .encrypt, algo) else { return nil }
            let blockSize = SecKeyGetBlockSize(key)
            let dataBlockSize = blockSize - 11
            let dataLen = data.count
            var ret = Data()
            var i = 0
            while i < dataLen {
                var error: Unmanaged<CFError>?
                guard let cipherText = SecKeyCreateEncryptedData(
                    key,
                    algo,
                    data[i..<min(dataLen, i+dataBlockSize)] as CFData,
                    &error
                ) as Data? else {
                    return nil
                }
                
                ret.append(cipherText)
                i += dataBlockSize
            }
            return ret
        } else {
            let bytesPtr = NSData(data: data).bytes
            let starterPtr = bytesPtr.bindMemory(to: UInt8.self, capacity: data.count)
            let dataLen = data.count
            var blockSize = SecKeyGetBlockSize(key)
            let dataBlockSize = blockSize - 11
            var ret: Data = Data()
            let output = UnsafeMutablePointer<UInt8>.allocate(capacity: blockSize)
            
            var i = 0
            while i<dataLen {
                let plainTextLen = min(dataLen - i, dataBlockSize)
                let status = SecKeyEncrypt(
                    key,
                    SecPadding.PKCS1,
                    starterPtr + i,
                    plainTextLen,
                    output,
                    &blockSize
                )
                if status != noErr {
                    return nil
                }
                ret.append(output, count: blockSize)
                i += dataBlockSize
            }
            return ret
        }
    }
    
    @objc
    static func encrypt(string str: String, withPublicKeyString keyStr: String) -> String? {
    guard let strData = str.data(using: .utf8) else {
        return nil
    }
    guard let encryptedData = encrypt(strData, withPublicKeyString: keyStr) else {
        return nil
    }
    return encryptedData.base64EncodedString(options: .lineLength64Characters)
}
    
    static func add(publicKeyString pubKey :String) -> SecKey?{
        let pubKey = pubKey
            .replacingOccurrences(of: "-----BEGIN PUBLIC KEY-----", with: "")
            .replacingOccurrences(of: "-----END PUBLIC KEY-----", with: "")
            .replacingOccurrences(of: "\r", with: "")
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\t", with: "")
            .replacingOccurrences(of: " ", with: "")
        guard let data = Data(base64Encoded: pubKey) else {
            return nil
        }
        guard let data = stripPublicKeyHeader(data) else {
            return nil
        }
        
        let tagData = "RSAUtil_PubKey".data(using: .utf8)!
        var query: [String: Any] = [
            kSecClass as String : kSecClassKey,
            kSecAttrKeyType as String : kSecAttrKeyTypeRSA,
            kSecAttrApplicationTag as String : tagData
        ]
        SecItemDelete(query as CFDictionary)
        
        query[kSecValueData as String] = data
        query[kSecAttrKeyClass as String] = kSecAttrKeyClassPublic
        query[kSecReturnPersistentRef as String] = NSNumber(booleanLiteral: true)
        var status = SecItemAdd(query as CFDictionary, nil)
        if status != noErr && status != errSecDuplicateItem {
            return nil
        }
        
        query.removeValue(forKey: kSecValueData as String)
        query.removeValue(forKey: kSecReturnPersistentRef as String)
        query[kSecReturnRef as String] = NSNumber(booleanLiteral: true)
        query[kSecAttrKeyType as String] = kSecAttrKeyTypeRSA
        
        var res: CFTypeRef?
        status = SecItemCopyMatching(query as CFDictionary, &res)
        if status != noErr {
            return nil
        }
        return (res as! SecKey)
    }
    
    private static func stripPublicKeyHeader(_ data: Data) -> Data? {
        var idx = 0
        if 0x30 != data[idx] {
            return nil
        }
        idx += 1
        if data[idx] > 0x80 {
            idx += Int(data[idx]) - 0x80 + 1;
        } else {
            idx += 1
        }
        let seqOID = [ 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00 ]
        for i in 0..<15{
            if seqOID[i] != data[idx+i] {
                return nil
            }
        }
        idx += 15
        if data[idx] != 0x03{
            return nil
        }
        idx += 1
        if data[idx] > 0x80 {
            idx += Int(data[idx]) - 0x80 + 1
        } else {
            idx += 1
        }
        if data[idx] != Character("\0").asciiValue{
            return nil
        }
        idx += 1
        return data[idx..<data.count]
    }
    
}
