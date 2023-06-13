/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

@objc (TTKSDKUtils)
public class TikTokUtils : NSObject {
    
    @objc
    public class func URLWith(originalURL: String, queryParams: Dictionary<String, Any>) -> URL? {
        if originalURL.isEmpty {
            return nil
        }
        if queryParams.isEmpty {
            return URL.init(string: originalURL)
        }
        var queryString = ""
        var seperator = ""
        for (k, obj) in queryParams {
            if let stringObj = obj as? String {
                queryString.append(contentsOf: String(format: "%@%@=%@", seperator, k, stringObj.urlEncodedString()))
            } else if let intObj = obj as? Int {
                queryString.append(contentsOf: String(format: "%@%@=%@", seperator, k, intObj))
            } else if let dictObj = obj as? Dictionary<String, Any> {
                queryString.append(contentsOf: String(format: "%@%@=%@", seperator, k, dictObj.serializedString().urlEncodedString()))
            } else if let arrayObj = obj as? Array<Any> {
                queryString.append(contentsOf: String(format: "%@%@=%@", seperator, k, arrayObj.serializedString().urlEncodedString()))
            }
            seperator = "&"
        }
        
        var targetURL = originalURL.trimmingCharacters(in: NSCharacterSet.whitespaces)
        queryString = queryString.trimmingCharacters(in: NSCharacterSet.whitespaces)
        if (!queryString.isEmpty) {
            if (!targetURL.contains("?")) {
                targetURL.append(contentsOf: "?")
            } else if (!targetURL.hasSuffix("?") && !targetURL.hasSuffix("&")) {
                targetURL.append(contentsOf: "&")
            }
            targetURL.append(contentsOf: queryString)
        }
        
        return !targetURL.isEmpty ? URL.init(string: targetURL) : nil
    }
    
    @objc
    public class func queryDictionaryFrom(url: URL) -> Dictionary<String, Any>? {
        var queryDict = Dictionary<String, Any>()
        if let queryString = url.query {
            let queryParams = queryString.components(separatedBy: "&")
            for queryParam in queryParams {
                let element = queryParam.components(separatedBy: "=")
                if (element.count != 2) {
                    continue
                }
                
                if let key = element[0].urlDecodedString(), let value = element[1].urlDecodedString() {
                    if let valueObject = value.deserializeJSONObject() {
                        queryDict[key] = valueObject
                    } else {
                        queryDict[key] = value
                    }
                    
                }
            }
        }
        
        return queryDict
    }
    
    @objc
    public class func TikTokIsInstalled() -> Bool {
        for scheme in TikTokInfo.schemes {
            if let schemeURL = URL(string: "\(scheme)://") {
                if UIApplication.shared.canOpenURL(schemeURL) {
                    return true
                }
            }
        }
        return false
    }
    
    @objc
    public class func TikTokLocalizedString(text: String) -> String {
        return text.localizedString()
    }
}

// MARK: Class extensions

public extension URL {
    
    func urlByAppendingQueryItems(items: Dictionary<String, Any>) -> URL? {
        return TikTokUtils.URLWith(originalURL: self.absoluteString, queryParams: items)
    }
    
    func queryDictionary() -> Dictionary<String, Any>? {
        return TikTokUtils.queryDictionaryFrom(url: self)
    }
    
}

public extension String {
    
    func localizedString(_ comment:String? = nil) -> String {
        guard let resPath = Bundle.TikTokBundle?.resourcePath else {
            return self
        }
        let identifier = Locale.current.TikTokSupportLangIdentifier()
        guard let langPath = Bundle(path: resPath)?.path(forResource: identifier, ofType: nil, inDirectory: "TikTokLocalizable") else {
            return self
        }
        let res = Bundle(path: langPath)?.localizedString(forKey: self, value: comment, table: "Passport")
        return res ?? self
    }
    
    func TikTokRSAEncrypted(withPublicKeyString key: String) -> String? {
        return TikTokRSA.encrypt(string: self, withPublicKeyString: key)
    }
    
    func urlEncodedString() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
    }
    
    func urlDecodedString() -> String? {
        return self.removingPercentEncoding
    }
    
    func deserializeJSONObject() -> Any? {
        var deserializedObject : Any?
        do {
            if let data = self.data(using: .utf8, allowLossyConversion: false) {
                deserializedObject = try JSONSerialization.jsonObject(with: data, options: [])
            }
            
        } catch {
            print("Deserialized error")
        }
        return deserializedObject
    }
    
    func queryDictionary() -> Dictionary<String, Any>? {
        if let strURL = URL.init(string: self) {
            return strURL.queryDictionary()
        }
        
        return nil
    }
    
}

public extension Dictionary where Key == String {
    
    func serializedString() -> String {
        var utf8Str = ""
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
            if (jsonData.isEmpty) {
                return utf8Str
            }
            
            utf8Str = String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
            
        } catch {
            print("serialization error")
        }
        return utf8Str
    }
    
    func integer(forKey: String) -> Int {
        return self[forKey] as? Int ?? 0
    }
    
    func float(forKey: String) -> Float {
        return self[forKey] as? Float ?? 0.0
    }
    
    func string(forKey: String) -> String? {
        return self[forKey] as? String ?? nil
    }
    
    func array(forKey: String) -> Array<Any>? {
        return self[forKey] as? Array ?? nil
    }
    
    func dictionary(forKey: String) -> Dictionary? {
        return self[forKey] as? Dictionary ?? nil
    }

}

public extension Array {
    
    func serializedString() -> String {
        var utf8Str = ""
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
            if (jsonData.isEmpty) {
                return utf8Str
            }
            
            utf8Str = String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
            
        } catch {
            print("serialization error")
        }
        return utf8Str
    }
    
}

public extension Bundle {
    
    static func TikTokGetBundle(ofName bundleName: String, withPodName podName: String) -> Bundle? {
        var bundleURL = Bundle.main.url(forResource: bundleName, withExtension: "bundle")
        if bundleURL == nil {
            bundleURL = Bundle.main.url(forResource: "Frameworks", withExtension: nil)
            bundleURL?.appendPathComponent(podName)
            bundleURL?.appendPathExtension("framework")
            if let frameworkBundleURL = bundleURL {
                let frameworkBundle = Self.init(url: frameworkBundleURL)
                bundleURL = frameworkBundle?.url(forResource: bundleName, withExtension: "bundle")
            }
        }
        if let url = bundleURL {
            return Self.init(url: url)
        }
        return nil
    }
    
    static var TikTokBundle: Bundle? {
        TikTokGetBundle(ofName: "TikTokOpenAuthSDK", withPodName: "TikTokOpenAuthSDK")
    }
}

public extension Locale {
    
    func TikTokSupportLangIdentifier() -> String {
        let suppoted = Set([
            "af", "ar", "bn", "ceb", "cs",
            "de", "el", "en", "es", "fil", "fr",
            "gu", "hi", "hu", "id", "it",
            "ja", "jv", "km", "kn", "ko", "ml", "mr", "ms", "my",
            "nl", "nso", "or", "pa", "pl", "pt_BR",
            "ro", "ru", "sv", "ta", "te", "th", "tr",
            "uk", "vi", "zh", "zh_TW", "zu",
        ])
        
        for prefered in Self.preferredLanguages {
            var searched = prefered
            switch prefered {
            case "zh-Hans":
                searched = "zh"
                break
            case (let p) where p.hasPrefix("zh-"):
                searched = "zh-TW"
                break
            case (let p) where p.hasPrefix("pt-BR"):
                searched = "pt-BR"
                break
            case (let p) where p.contains("-"):
                searched = p.components(separatedBy: "-").first!
                break
            default:
                continue
            }
            if suppoted.contains(searched){
                return searched
            }
        }
        return "en"
    }
    
    func TikTokIsLTR() -> Bool {
        TikTokSupportLangIdentifier() != "ar"
    }
    
}

public extension URL {
    func TikTokQueryDict() -> [String: String]? {
        guard let comps = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return nil
        }
        guard let dict = comps.queryItems else {
            return nil
        }
        return dict.reduce(into: [String: String]()){ $0[$1.name] = $1.value }
    }
}
