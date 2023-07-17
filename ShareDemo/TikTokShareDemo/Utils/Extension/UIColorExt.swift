/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit

extension UIColor {
    static var backgroundColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ? .black : .white
            }
        } else {
            return .white
        }
    }

    static var textColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ? .white : .black
            }
        } else {
            return .black
        }
    }

    static var displayCellBackgroundColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ? UIColor(red: 22/255.0, green: 24/255.0, blue: 35/255.0, alpha: 0.96) : UIColor(red: 22/255.0, green: 24/255.0, blue: 35/255.0, alpha: 0.06)
            }
        } else {
            return UIColor(red: 22/255.0, green: 24/255.0, blue: 35/255.0, alpha: 0.06)
        }
    }
}
