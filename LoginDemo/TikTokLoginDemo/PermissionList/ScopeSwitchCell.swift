/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

class ScopeSwitchCell: ListSwitchCell<ScopeListItem> {
    override func setUp(withItem item: ScopeListItem) {
        titleView.text = item.title
        subtitleView.text = item.subtitle
        switchView.isOn = item.default
        if item.isRequired {
            switchView.addTarget(self, action: #selector(setSwitchOn), for: .valueChanged)
        }
        switchView.addTarget(self, action: #selector(propagateChange), for: .valueChanged)
    }

    @objc
    func setSwitchOn() {
        switchView.setOn(true, animated: true)
    }
}
