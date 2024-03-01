/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

class BottomBarViewController: UIViewController {

    let authBtn: UIButton = {
        let authBtn = UIButton()
        authBtn.translatesAutoresizingMaskIntoConstraints = false
        authBtn.setTitle("Authorize", for: .normal)
        authBtn.setTitleColor(.backgroundColor, for: .normal)
        authBtn.backgroundColor = UIColor(red: 254/255.0, green: 44/255.0, blue: 85/255.0, alpha: 1)
        authBtn.layer.cornerRadius = 5
        return authBtn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundColor
        view.addSubview(authBtn)

        NSLayoutConstraint.activate([
            authBtn.heightAnchor.constraint(equalToConstant: 48),
            authBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            authBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            authBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 3.5),
            authBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -3.5)
        ])

    }
}
