/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

class ListDisplayCell<T: ListItem>: ListBaseCell<T> {
    let titleView: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textColor
        label.font = .boldSystemFont(ofSize: 16.0)
        return label
    }()

    let valueLabelView: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = .systemFont(ofSize: 13.0)
        return label
    }()

    let subtitleView: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14.0)
        label.numberOfLines = 0
        return label
    }()

    let bgView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .displayCellBackgroundColor
        view.layer.cornerRadius = 5
        return view
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
        container.addSubview(subtitleView)
        container.addSubview(bgView)
        bgView.addSubview(titleView)
        bgView.addSubview(valueLabelView)

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
            titleView.widthAnchor.constraint(lessThanOrEqualTo: bgView.widthAnchor),
            titleView.rightAnchor.constraint(equalTo: valueLabelView.leftAnchor)
        ])

        NSLayoutConstraint.activate([
            valueLabelView.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            valueLabelView.rightAnchor.constraint(equalTo: bgView.rightAnchor, constant: -8),
            valueLabelView.widthAnchor.constraint(lessThanOrEqualTo: bgView.widthAnchor)
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
