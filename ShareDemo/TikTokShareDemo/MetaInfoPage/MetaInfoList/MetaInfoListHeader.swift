/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

class MetaInfoLIstHeader: ListBaseHeader<MetaInfoListSection> {
    override func setUp(withSection sec: MetaInfoListSection) {
        label.text = sec.title
        imgView.isHidden = true
        adjustTitleView()
    }
}
