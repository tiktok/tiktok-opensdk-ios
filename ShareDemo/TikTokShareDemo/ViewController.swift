/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let permEdit = AppInfoViewController()
        add(childViewController: permEdit)
        view.backgroundColor = .backgroundColor

        NSLayoutConstraint.activate([
            permEdit.view.topAnchor.constraint(equalTo: view.topSafeAnchor),
            permEdit.view.leftAnchor.constraint(equalTo: view.leftSafeAnchor),
            permEdit.view.rightAnchor.constraint(equalTo: view.rightSafeAnchor),
            permEdit.view.bottomAnchor.constraint(equalTo: view.bottomSafeAnchor)
        ])

    }

}
