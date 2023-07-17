/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

class AppInfoListSwitchCell: ListSwitchCell<AppInfoListItem> {
    override func setUp(withItem: AppInfoListItem) {
        titleView.text = withItem.title
        subtitleView.text = withItem.subtitle
        guard let def = withItem.default as? Bool else {
            switchView.isOn = false
            return
        }
        switchView.isOn = def
        switchView.addTarget(self, action: #selector(propagateChange), for: .valueChanged)
    }
}
