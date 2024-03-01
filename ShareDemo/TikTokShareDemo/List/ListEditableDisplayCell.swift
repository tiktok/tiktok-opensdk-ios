/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit

class ListEditableDisplayCell<T: ListItem>: ListBaseCell<T> {
    let titleView: UILabel = {
        let titleView = UILabel(frame: .zero)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.textColor = .textColor
        titleView.font = .boldSystemFont(ofSize: 16.0)
        return titleView
    }()

    let valueTextField: UITextField = {
        let view = UITextField(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 14.0)
        view.textAlignment = .right
        view.isEnabled = false
        return view
    }()

    let subtitleView: UILabel = {
        let subtitleView = UILabel(frame: .zero)
        subtitleView.translatesAutoresizingMaskIntoConstraints = false
        subtitleView.textColor = .gray
        subtitleView.font = .systemFont(ofSize: 14.0)
        subtitleView.numberOfLines = 0
        return subtitleView
    }()

    let bgView: UIView = {
        let bgView = UIView(frame: .zero)
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.backgroundColor = .displayCellBackgroundColor
        bgView.layer.cornerRadius = 5
        return bgView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpLayout()
    }

    func setUpLayout() {
        selectionStyle = .none
        backgroundColor = .clear

        container.backgroundColor = .clear
        container.addSubview(subtitleView)
        container.addSubview(bgView)
        bgView.addSubview(titleView)
        bgView.addSubview(valueTextField)

        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: container.topAnchor),
            bgView.leftAnchor.constraint(equalTo: container.leftAnchor),
            bgView.rightAnchor.constraint(equalTo: container.rightAnchor),
            bgView.heightAnchor.constraint(equalToConstant: 48.0)
        ])

        // Title View
        NSLayoutConstraint.activate([
            titleView.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            titleView.leftAnchor.constraint(equalTo: bgView.leftAnchor, constant: 8),
            titleView.widthAnchor.constraint(equalTo: bgView.widthAnchor, multiplier: 0.33)
        ])
        // TextField
        NSLayoutConstraint.activate([
            valueTextField.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            valueTextField.rightAnchor.constraint(equalTo: bgView.rightAnchor, constant: -8),
            valueTextField.leftAnchor.constraint(equalTo: titleView.rightAnchor, constant: 8),
            valueTextField.heightAnchor.constraint(equalTo: bgView.heightAnchor, multiplier: 2.0 / 3.0)
        ])

        // Subtitle View
        NSLayoutConstraint.activate([
            subtitleView.topAnchor.constraint(equalTo: bgView.bottomAnchor, constant: 5),
            subtitleView.leftAnchor.constraint(equalTo: container.leftAnchor),
            subtitleView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            subtitleView.rightAnchor.constraint(equalTo: container.rightAnchor)
        ])
    }

    override func setUp(withItem: T) {}

    override func bind(withPropogateClosure cls: @escaping ((Any?) -> Void)) { }
}
