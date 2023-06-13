/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit
import TikTokOpenShareSDK

class MetaInfoViewController: UIViewController {
    private lazy var metaListViewController = MetaInfoListViewController()
    private lazy var bottomBarViewController = BottomBarViewController()
    private var request: TikTokShareRequest?

    var listViewModel: MetaInfoListViewModel?

    func setUpLayout() {
        add(childViewController: metaListViewController)
        add(childViewController: bottomBarViewController)

        NSLayoutConstraint.activate([
            metaListViewController.view.topAnchor.constraint(equalTo: view.topSafeAnchor),
            metaListViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            metaListViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            metaListViewController.view.bottomAnchor.constraint(equalTo: bottomBarViewController.view.topAnchor)
        ])

        NSLayoutConstraint.activate([
            bottomBarViewController.view.bottomAnchor.constraint(equalTo: view.bottomSafeAnchor),
            bottomBarViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            bottomBarViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

    init(withMediaType type: QBImagePickerMediaType, assets: [String], customClientKey: String? = nil) {
        super.init(nibName: nil, bundle: nil)
        setUp(withMediaType: type, assets: assets, customClientKey: customClientKey)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setUp(withMediaType type: QBImagePickerMediaType, assets: [String], customClientKey: String? = nil) {
        guard assets.count > 0 else {
            return
        }

        listViewModel = MetaInfoListViewModel()
        listViewModel?.customClientKey = customClientKey ?? (Bundle.main.infoDictionary?["TikTokClientKey"] as? String)
        listViewModel?.callerUrlScheme = (Bundle.main.infoDictionary?["TikTokClientKey"] as? String)
        listViewModel?.media = assets
        listViewModel?.mediaType = type == .video ? .video : .image
        metaListViewController.viewModel = listViewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        title = "Edit Meta Info"
        setUpLayout()
        bottomBarViewController.publishBtn.addTarget(self, action: #selector(shareMedia), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    @objc
    private func shareMedia() {
        request = listViewModel?.toRequest()
        request?.send { [weak self] response in
            guard let self = self, let shareResponse = response as? TikTokShareResponse else { return }
            var alertStr = "Share Succeeded!"
            if shareResponse.errorCode != .noError {
                alertStr = "Share Failed!\n Error Code: \(shareResponse.errorCode.rawValue)\n Error Message: \(shareResponse.errorDescription ?? "")"
            }
            let alertVC = UIAlertController(title: nil, message: alertStr, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Back", style: .cancel))
            self.present(alertVC, animated: true)
            self.request = nil
        }
    }
}
