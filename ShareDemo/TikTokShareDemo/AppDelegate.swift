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
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "MainViewController")
        let navigationVC = UINavigationController(rootViewController: viewController)
        navigationVC.navigationBar.barStyle = .default
        navigationVC.navigationBar.backgroundColor = .backgroundColor
        navigationVC.navigationBar.tintColor = .textColor
        navigationVC.navigationBar.shadowImage = nil
        navigationVC.navigationBar.isTranslucent = false
        navigationVC.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.textColor]
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.shadowColor = .clear
            appearance.backgroundColor = .backgroundColor
            appearance.titleTextAttributes[NSAttributedString.Key.foregroundColor] = UIColor.textColor
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }

        window?.rootViewController = navigationVC
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
