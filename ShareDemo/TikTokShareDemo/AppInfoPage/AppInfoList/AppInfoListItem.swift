/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

struct AppInfoListItem: ListItem {
    let title: String
    let subtitle: String
    var isEditable: Bool
    let cellType: ListBaseCell<Self>.Type
    var `default`: Any?
    var propagateChange: ((Any?, AppInfoListViewModel, AppInfoListItem) -> Void)?
    var setDefault: ((AppInfoListViewModel, inout AppInfoListItem) -> Void)?

    func propagate(change: Any?, toViewModel viewModel: ListViewModel) {
        guard let propagateChange = propagateChange else {
            return
        }
        guard let viewModel = viewModel as? AppInfoListViewModel else {
            return
        }
        propagateChange(change, viewModel, self)
    }

    func getCellType() -> ListBaseCell<Self>.Type { cellType }

    mutating func setDefault(fromViewModel viewModel: ListViewModel) {
        guard let setDefault = self.setDefault, let viewModel = viewModel as? AppInfoListViewModel else {
            return
        }
        setDefault(viewModel, &self)
    }

    static let cellTypeDict = [
        "AppInfoDisplayCell": AppInfoListDisplayCell.self,
        "AppInfoSwitchCell": AppInfoListSwitchCell.self,
        "AppInfoListEditableDisplayCell": AppInfoListEditableDisplayCell.self
    ]
}
