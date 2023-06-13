/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

class ScopeListHeader: ListBaseHeader<ScopeListSection> {

    override func setUp(withSection sec: ScopeListSection) {
        label.text = sec.headerTitle
        imgView.isHidden = sec.hideImg
        adjustTitleView()
    }
}
