/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit
import TikTokOpenSDKCore

class AppInfoViewController: UIViewController {
    var listViewController: AppInfoListViewController = {
        return  AppInfoListViewController()
    }()

    lazy var bottombarViewController: BottomBarViewController = {
        let underlyingBottomBarViewController = BottomBarViewController()
        underlyingBottomBarViewController.publishBtn.setTitle("Share", for: .normal)
        underlyingBottomBarViewController.publishBtn.addTarget(self, action: #selector(tapPublishBtn), for: .touchUpInside)
        return underlyingBottomBarViewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUp()
    }

    func setUp() {
        view.translatesAutoresizingMaskIntoConstraints = true
        let listVC = listViewController
        listVC.view.translatesAutoresizingMaskIntoConstraints = false
        add(childViewController: listVC)
        let bottomBarVC = bottombarViewController
        bottomBarVC.view.translatesAutoresizingMaskIntoConstraints = false
        add(childViewController: bottomBarVC)

        NSLayoutConstraint.activate([
            listVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            listVC.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            listVC.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            listVC.view.bottomAnchor.constraint(equalTo: bottomBarVC.view.topAnchor)
        ])

        NSLayoutConstraint.activate([
            bottombarViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomSafeAnchor),
            bottombarViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            bottombarViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

    @objc
    func tapPublishBtn() {
        navigationController?.pushViewController(SelectMediaViewController(listViewController.customClientKey), animated: true)
    }

}
