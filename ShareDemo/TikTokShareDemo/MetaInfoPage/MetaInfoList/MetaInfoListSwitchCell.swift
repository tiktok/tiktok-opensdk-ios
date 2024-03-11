/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

class MetaInfoListSwitchCell: ListSwitchCell<MetaInfoListItem> {

    override func setUp(withItem item: MetaInfoListItem) {
        titleView.text = item.title
        subtitleView.text = item.subtitle
        guard let def = item.default as? Bool else {
            return
        }
        switchView.isOn = def
        switchView.addTarget(self, action: #selector(propagateChange), for: .valueChanged)
    }

}
