/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

class PermissionDisplayCell: ListDisplayCell {
    override func setUp(withItem item: ListItemProtocol) {
        super.setUp(withItem: item)
        guard let it = item as? PermissionListItem else {
            return
        }
        titleView.text = it.title
        subtitleView.text = it.subtitle
        guard let def = it.default as? String else {
            return
        }
        valueLabelView.text = def
    }
}
