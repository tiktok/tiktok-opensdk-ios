/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit
import TikTokOpenSDKCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        window = UIWindow()
        let navigationVC = UINavigationController(rootViewController: ScopeEditViewController())
        navigationVC.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()
        return true
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        if TikTokURLHandler.handleOpenURL(url) {
            return true
        }
        return false
    }
    
    func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        if (TikTokURLHandler.handleOpenURL(userActivity.webpageURL)) {
            return true
        }
        return false
    }
    
}
