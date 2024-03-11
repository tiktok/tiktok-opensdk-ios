/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

// MARK: - ScopeCell Related Classes
enum ScopeCellType: String, CaseIterable {
    case `switch`           = "ScopeCellSwitch"
    case textInput          = "ScopeCellTextInput"

    func toClass() -> ListBaseCell<ScopeListItem>.Type {
        switch self {
        case .switch:
            return ScopeSwitchCell.self
        case .textInput:
            return ScopeTextInputCell.self
        }
    }
}

struct ScopeListSection: ListSection {
    typealias Item = ScopeListItem
    func getHeaderType() -> ListBaseHeader<Self>.Type {
        ScopeListHeader.self
    }

    let headerTitle: String
    let hideImg: Bool
    let items: [ScopeListItem]
    func getItems() -> [ScopeListItem] { items }
}

struct ScopeListItem: ListItem {
    let title: String?
    let subtitle: String?
    let type: ScopeCellType
    let isRequired: Bool
    let setDefault: (ScopeListViewModel, inout ScopeListItem) -> Void
    let propagateChange: ((Any?, ScopeListViewModel, ScopeListItem) -> Void)?
    var `default`: Bool

    mutating func setDefault(fromViewModel viewModel: ListViewModel) {
        guard let viewModel = viewModel as? ScopeListViewModel else {
            return
        }
        setDefault(viewModel, &self)
    }

    func propagate(change: Any?, toViewModel viewModel: ListViewModel ) {
        guard let viewModel = viewModel as? ScopeListViewModel else {
            return
        }
        propagateChange?(change, viewModel, self)
    }

    func getCellType() -> ListBaseCell<Self>.Type {
        type.toClass()
    }
}
