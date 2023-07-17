/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */
import UIKit

class ScopeTextInputCell: ListTextInputCell<ScopeListItem> {
    override func setUp(withItem item: ScopeListItem) {
        super.setUp(withItem: item)
        titleView.text = item.title
        subtitleView.text = item.subtitle
    }
}
