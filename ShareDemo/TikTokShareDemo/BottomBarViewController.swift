/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

class BottomBarViewController: UIViewController {
    let publishBtn: UIButton = {
        let publishBtn = UIButton()
        publishBtn.translatesAutoresizingMaskIntoConstraints = false
        publishBtn.setTitle("Publish", for: .normal)
        publishBtn.setTitleColor(UIColor.white, for: .normal)
        publishBtn.backgroundColor = UIColor(red: 254/255.0, green: 44/255.0, blue: 85/255.0, alpha: 1)
        publishBtn.layer.cornerRadius = 5
        return publishBtn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    private func setUp() {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundColor
        view.addSubview(publishBtn)

        NSLayoutConstraint.activate([
            publishBtn.heightAnchor.constraint(equalToConstant: 48),
            publishBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            publishBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            publishBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 3.5),
            publishBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -3.5)
        ])
    }
}
