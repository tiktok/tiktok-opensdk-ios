/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */
import UIKit

class ListTextInputCell<T: ListItem>: ListBaseCell<T>, UITextFieldDelegate {
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

    let textFieldContainer: UIView = {
        let textFieldContainer = UIView()
        textFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        textFieldContainer.backgroundColor = .clear
        textFieldContainer.layer.masksToBounds = true
        textFieldContainer.layer.borderWidth = 1
        textFieldContainer.layer.borderColor = UIColor.lightGray.cgColor
        textFieldContainer.layer.cornerRadius = 5
        return textFieldContainer
    }()

    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .textColor
        textField.delegate = self
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.returnKeyType = .done
        return textField
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
        container.addSubview(textFieldContainer)
        textFieldContainer.addSubview(textField)

        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: container.topAnchor),
            titleView.leftAnchor.constraint(equalTo: container.leftAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 23),
            titleView.rightAnchor.constraint(equalTo: container.rightAnchor)
        ])

        NSLayoutConstraint.activate([
            textFieldContainer.leftAnchor.constraint(equalTo: container.leftAnchor),
            textFieldContainer.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 5),
            textFieldContainer.heightAnchor.constraint(equalToConstant: 48),
            textFieldContainer.rightAnchor.constraint(equalTo: container.rightAnchor)
        ])

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: textFieldContainer.topAnchor, constant: 5),
            textField.leftAnchor.constraint(equalTo: textFieldContainer.leftAnchor, constant: 10),
            textField.rightAnchor.constraint(equalTo: textFieldContainer.rightAnchor, constant: -10),
            textField.bottomAnchor.constraint(equalTo: textFieldContainer.bottomAnchor, constant: -5)
        ])

        NSLayoutConstraint.activate([
            subtitleView.topAnchor.constraint(equalTo: textFieldContainer.bottomAnchor, constant: 5),
            subtitleView.leftAnchor.constraint(equalTo: container.leftAnchor),
            subtitleView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            subtitleView.rightAnchor.constraint(equalTo: container.rightAnchor)
        ])
    }

    override func setUp(withItem: T) {
        textField.addTarget(self, action: #selector(propagateChange), for: .editingDidEnd)
    }

    var propagateClosure: ((Any?) -> Void)?

    override func bind(withPropogateClosure cls: @escaping ((Any?) -> Void)) {
        propagateClosure = cls
    }

    @objc
    func propagateChange() {
        guard let propagateClosure = propagateClosure else {
            return
        }
        guard let text = textField.text else {
            return
        }
        propagateClosure(text)
    }

    // MARK: - TextField Delegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
