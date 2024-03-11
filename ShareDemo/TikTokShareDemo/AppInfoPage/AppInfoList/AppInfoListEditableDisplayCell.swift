/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit

class AppInfoListEditableDisplayCell: ListEditableDisplayCell<AppInfoListItem> {
    override func setUp(withItem item: AppInfoListItem) {
        titleView.text = item.title
        subtitleView.text = item.subtitle
        guard let def = item.default as? String else {
            return
        }
        valueTextField.attributedPlaceholder = NSAttributedString.init(string: def, attributes: [.foregroundColor: UIColor.gray])
        valueTextField.isEnabled = item.isEditable
    }
}
