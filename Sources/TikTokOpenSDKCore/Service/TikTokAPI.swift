/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

@objc (TTKSDKAPI)
public class TikTokAPI : NSObject {
    private static var requests: NSMapTable<NSString, TikTokBaseRequest> = NSMapTable.strongToWeakObjects()
    
    // MARK: - Public
    static public func add(request: TikTokBaseRequest) {
        requests.setObject(request, forKey: request.requestID as NSString)
    }
    
    static public func remove(requestID: String) {
        requests.removeObject(forKey: requestID as NSString)
    }
    
    static func handle(url: URL) -> Bool {
        guard let valueEnumerator = requests.objectEnumerator() else { return false }
        while let nextObject = valueEnumerator.nextObject(), let request = nextObject as? TikTokBaseRequest {
            if request.service.handleResponseURL(url: url) {
                return true
            }
        }
        return false
    }
}
