/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit

public protocol TikTokURLOpener {
    func canOpenURL(_ url: URL) -> Bool
    var keyWindow: UIWindow? { get }
    func isTikTokInstalled() -> Bool
}

@objc
extension UIApplication : TikTokURLOpener {
    @objc
    public func isTikTokInstalled() -> Bool {
        for scheme in TikTokInfo.schemes {
            if let schemeURL = URL(string: "\(scheme)://") {
                if canOpenURL(schemeURL) {
                    return true
                }
            }
        }
        return false
    }
    
}
