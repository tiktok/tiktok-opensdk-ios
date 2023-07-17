/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

// MARK: - Tap to exit editing mode
fileprivate extension UIViewController {
    func setUpHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }

    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }

    func setUpKeyboardLayout(inTableView tableView: UITableView) {
        NotificationCenter.default.addObserver(
            forName: Self.keyboardWillShowNotification,
            object: nil,
            queue: OperationQueue.main
        ) { note in
            guard let size = (note.userInfo?[Self.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
            }
            let insect = UIEdgeInsets(top: 0, left: 0, bottom: size.height, right: 0)
            tableView.contentInset = insect
            tableView.scrollIndicatorInsets = insect
        }

        NotificationCenter.default.addObserver(
            forName: Self.keyboardWillHideNotification,
            object: nil,
            queue: OperationQueue.main
        ) { _ in
            tableView.contentInset = .zero
            tableView.scrollIndicatorInsets = .zero
        }
    }
}

// MARK: - Permission List View Controller
class ListViewController<T: ListItem, S: ListSection, VM: ListViewModel>: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var viewModel: VM?
    var data: [S] { [] }
    var cellIdTypeDict: [String: ListBaseCell<T>.Type] { [:] }
    var headerIdTypeDict: [String: ListBaseHeader<S>.Type] { [:] }

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 50
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.indicatorStyle = .black
        cellIdTypeDict.forEach { key, val in
            tableView.register(val, forCellReuseIdentifier: key)
        }
        headerIdTypeDict.forEach { key, val in
            tableView.register(val, forHeaderFooterViewReuseIdentifier: key)
        }
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        setUpKeyboardLayout(inTableView: self.tableView)
        setUpHideKeyboardOnTap()
    }

    // MARK: - TableViewDelegate

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let id = headerIdTypeDict.first(where: { $1 ==  data[section].getHeaderType()})?.key else {
            return nil
        }
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: id) as? ListBaseHeader<S> else {
            return nil
        }
        header.setUp(withSection: data[section])
        return header
    }

    // MARK: - DataSource methods
    func numberOfSections(in tableView: UITableView) -> Int { data.count }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { data[section].getItems().count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard var item: T = data[indexPath.section].getItems()[indexPath.row] as? T else { return UITableViewCell() }
        let identifier = cellIdTypeDict.first(where: { $1 == item.getCellType() })!.key
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! ListBaseCell<T>

        if let viewModel = viewModel {
            item.setDefault(fromViewModel: viewModel)
            cell.bind { val in
                item.propagate(change: val, toViewModel: viewModel)
            }
        }
        cell.setUp(withItem: item)
        return cell
    }
}
