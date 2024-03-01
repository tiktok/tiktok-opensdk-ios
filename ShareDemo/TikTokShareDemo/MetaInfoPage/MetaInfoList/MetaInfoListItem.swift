/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

struct MetaInfoListItem: ListItem {

    let title: String
    let subtitle: String
    let cellType: ListBaseCell<Self>.Type

    var propagate: ((Any?, MetaInfoListViewModel, MetaInfoListItem) -> Void)?
    var setDefault: ((MetaInfoListViewModel, inout MetaInfoListItem) -> Void)?

    var `default`: Any?

    func propagate(change: Any?, toViewModel viewModel: ListViewModel) {
        guard let viewModel = viewModel as? MetaInfoListViewModel else {
            return
        }
        propagate?(change, viewModel, self)
    }

    func getCellType() -> ListBaseCell<Self>.Type { cellType }

    mutating func setDefault(fromViewModel viewModel: ListViewModel) {
        guard let viewModel = viewModel as? MetaInfoListViewModel else {
            return
        }
        setDefault?(viewModel, &self)
    }
}
