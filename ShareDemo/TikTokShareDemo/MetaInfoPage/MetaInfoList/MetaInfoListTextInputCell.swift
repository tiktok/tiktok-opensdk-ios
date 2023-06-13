/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

class MetaInfoListTextInputCell: ListTextInputCell<MetaInfoListItem> {
    override func setUp(withItem item: MetaInfoListItem) {
        titleView.text = item.title
        subtitleView.text = item.subtitle
        guard let def = item.default as? String else {
            return
        }
        textField.text = def
    }
}
