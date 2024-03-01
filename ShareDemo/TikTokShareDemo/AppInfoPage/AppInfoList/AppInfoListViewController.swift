/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

class AppInfoListViewController: ListViewController<AppInfoListItem, AppInfoListSection, AppInfoListViewModel> {
    private weak var customClientKeyCell: AppInfoListEditableDisplayCell?

    var customClientKey: String? {
        guard let viewModel = viewModel else { return nil }
        guard viewModel.customClientKeyEnabled else { return nil }
        return customClientKeyCell?.valueTextField.text?.trimmingCharacters(in: .whitespaces)
    }

    override var data: [AppInfoListSection] {
        appInfoLIstContent
    }

    override var cellIdTypeDict: [String: ListBaseCell<AppInfoListItem>.Type] {
        AppInfoListItem.cellTypeDict
    }

    override var headerIdTypeDict: [String: ListBaseHeader<AppInfoListSection>.Type] {
        ["Header": AppInfoListHeader.self]
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let infoListVM = AppInfoListViewModel()
        self.viewModel = infoListVM

        infoListVM.$customClientKeyEnabled.addObserver { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UIView.performWithoutAnimation {
                    self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        guard let viewModel = viewModel else { return cell }
        if let editableCell = cell as? AppInfoListEditableDisplayCell {
            customClientKeyCell = editableCell
            editableCell.valueTextField.isEnabled = viewModel.customClientKeyEnabled
        }
        return cell
    }
}
