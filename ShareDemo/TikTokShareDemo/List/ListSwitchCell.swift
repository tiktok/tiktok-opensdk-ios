/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */
import UIKit

class ListSwitchCell<T: ListItem>: ListBaseCell<T> {
    let titleView: UILabel = {
        let titleView = UILabel(frame: .zero)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.textColor = .textColor
        titleView.font = .boldSystemFont(ofSize: 16.0)
        return titleView
    }()

    let subtitleView: UILabel = {
        let subtitleView = UILabel(frame: .zero)
        subtitleView.translatesAutoresizingMaskIntoConstraints = false
        subtitleView.textColor = .gray
        subtitleView.font = .systemFont(ofSize: 14.0)
        subtitleView.numberOfLines = 0
        return subtitleView
    }()

    let switchView: UISwitch = {
        let switchView = UISwitch(frame: .zero)
        switchView.translatesAutoresizingMaskIntoConstraints = false
        switchView.onTintColor = UIColor(red: 11/255.0, green: 224/255.0, blue: 155/255.0, alpha: 1)
        return switchView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpLayout()
    }

    private func setUpLayout() {
        selectionStyle = .none
        backgroundColor = .clear

        container.backgroundColor = .clear
        container.addSubview(titleView)
        container.addSubview(subtitleView)
        container.addSubview(switchView)

        // Title View
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: container.topAnchor),
            titleView.leftAnchor.constraint(equalTo: container.leftAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 23),
            titleView.rightAnchor.constraint(equalTo: container.rightAnchor)
        ])

        // Subtitle View
        NSLayoutConstraint.activate([
            subtitleView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            subtitleView.leftAnchor.constraint(equalTo: container.leftAnchor),
            subtitleView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            subtitleView.widthAnchor.constraint(lessThanOrEqualToConstant: 300)
        ])

        // Switch View
        NSLayoutConstraint.activate([
            switchView.topAnchor.constraint(equalTo: container.topAnchor),
            switchView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -5)
        ])
    }

    override func setUp(withItem: T) {}

    var propagateClosure: ((Any?) -> Void)?

    override func bind(withPropogateClosure cls: @escaping((Any?) -> Void)) {
        propagateClosure = cls
    }

    @objc
    func propagateChange() {
        guard let cls = propagateClosure else {
            return
        }
        cls(switchView.isOn)
    }
}
