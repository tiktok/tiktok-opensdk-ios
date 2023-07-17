/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

class AppInfoListHeader: ListBaseHeader<AppInfoListSection> {
    override func setUp(withSection sec: AppInfoListSection) {
        label.text = sec.title
        adjustTitleView()
    }
}
