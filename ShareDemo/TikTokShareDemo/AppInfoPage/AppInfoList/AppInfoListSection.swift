/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

struct AppInfoListSection: ListSection {
    typealias Item = AppInfoListItem
    let title: String
    let items: [AppInfoListItem]
    func getItems() -> [AppInfoListItem] { items }
    func getHeaderType() -> ListBaseHeader<Self>.Type { AppInfoListHeader.self }
}
