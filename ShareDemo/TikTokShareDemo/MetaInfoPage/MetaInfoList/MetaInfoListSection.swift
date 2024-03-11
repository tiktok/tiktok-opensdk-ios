/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

struct MetaInfoListSection: ListSection {
    typealias Item = MetaInfoListItem

    let title: String
    let items: [MetaInfoListItem]

    func getItems() -> [MetaInfoListItem] { items }
    func getHeaderType() -> ListBaseHeader<Self>.Type { MetaInfoLIstHeader.self }
}
