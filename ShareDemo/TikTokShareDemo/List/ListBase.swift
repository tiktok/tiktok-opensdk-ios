/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

protocol ListViewModel {}

protocol ListItem {
    func propagate(change: Any?, toViewModel: ListViewModel)
    func getCellType() -> ListBaseCell<Self>.Type
    mutating func setDefault(fromViewModel: ListViewModel)
}

protocol ListSection {
    associatedtype Item: ListItem
    func getItems() -> [Item]
    func getHeaderType() -> ListBaseHeader<Self>.Type
}

protocol ListCell {
    associatedtype Item: ListItem
    func setUp(withItem: Item)
    func bind(withPropogateClosure: @escaping((Any?) -> Void))
}

protocol ListHeader: UITableViewHeaderFooterView {
    associatedtype T: ListSection
    func setUp(withSection: T)
}

class ListBaseCell<T: ListItem>: UITableViewCell, ListCell {
    lazy var container: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .clear
        self.contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            containerView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            containerView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15)
        ])
        return containerView
    }()

    func setUp(withItem: T) {
        fatalError("Override This!")
    }

    func bind(withPropogateClosure: @escaping ((Any?) -> Void)) {
        fatalError("Override This!")
    }
}

class ListBaseHeader<T: ListSection>: UITableViewHeaderFooterView, ListHeader {
    func setUp(withSection: T) {
        fatalError("Override This!")
    }
    let imgView: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "PicDevelopers"))
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()

    let label: UILabel = {
        let label = UILabel()
        label.textColor = .textColor
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUpLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpLayout()
    }

    private func setUpLayout() {
        contentView.addSubview(imgView)
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imgView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imgView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imgView.heightAnchor.constraint(equalToConstant: 194)
        ])
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 15),
            label.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    /// Adjust label based on if the imgView is hidden or not3
    func adjustTitleView() {
        if imgView.isHidden {
            NSLayoutConstraint.deactivate([
                label.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 15)
            ])
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
                imgView.heightAnchor.constraint(equalToConstant: 0.0)
            ])
        } else {
            NSLayoutConstraint.deactivate([
                label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
                imgView.heightAnchor.constraint(equalToConstant: 0.0)
            ])
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 15)
            ])
        }
    }
}
