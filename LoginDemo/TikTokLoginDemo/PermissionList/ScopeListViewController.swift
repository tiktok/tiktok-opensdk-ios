/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

// MARK: - Scope List View Controller
class ScopeListViewController: ListViewController<ScopeListItem, ScopeListSection, ScopeListViewModel> {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        viewModel = ScopeListViewModel()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    override var cellIdTypeDict: [String: ListBaseCell<ScopeListItem>.Type] {
        ScopeCellType.allCases.reduce(
            into: [String: ListBaseCell.Type](), { $0[$1.rawValue] = $1.toClass() }
        )
    }

    override var headerIdTypeDict: [String: ListBaseHeader<ScopeListSection>.Type] {
        [ "Header": ScopeListHeader.self ]
    }

    override var data: [ScopeListSection] {
        ScopeListContent
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = super.tableView(tableView, cellForRowAt: indexPath) as? ListBaseCell<ScopeListItem> else { return UITableViewCell() }
        let item: ScopeListItem = data[indexPath.section].getItems()[indexPath.row]
        if item.isRequired {
            cell.bind { [weak self] _ in
                guard let self = self else { return }
                let alert = UIAlertController(title: "Cannot disable this scope", message: "user.info.basic is a required scope", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: .default))
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
            }
        }
        return cell
    }
}
