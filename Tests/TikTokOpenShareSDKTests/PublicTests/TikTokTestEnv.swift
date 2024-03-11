/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit
@testable import TikTokOpenSDKCore
@testable import TikTokOpenShareSDK

open class MockURLOpener: TikTokURLOpener {
    
    private(set) var tiktokInstalled: Bool
    
    init(tiktokInstalled: Bool = true) {
        self.tiktokInstalled = tiktokInstalled
    }
    
    public func canOpenURL(_ url: URL) -> Bool {
        return true
    }
    
    public func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler completion: ((Bool) -> Void)?) {
        completion?(true)
    }
    
    @objc
    public func isTikTokInstalled() -> Bool {
        return tiktokInstalled
    }
    
    @objc
    public var keyWindow: UIWindow? {
        UIApplication.shared.keyWindow
    }
}

@objc
open class MockBundle: NSObject {
    @objc
    func infoDictionary() -> [String: Any]? {
        return ["TikTokClientKey": "aaaa"]
    }
    
    @objc
    func bundleIdentifier() -> String {
        return "org.cocoapods.AppHost-TikTokOpenShareSDK-Unit-Tests"
    }
}

class TikTokTestEnv {
    static var initialized = false
    
    static func setUpEnv() {
        if !initialized {
            initialized = true
            ttsdk_swizzleBundleIdentifier()
            ttsdk_swizzleBundleInfoDictionary()
        }
    }
    
    private static func ttsdk_swizzleBundleInfoDictionary() {
        enableTestMethodSwizzle(Bundle.self,
                                #selector(getter: Bundle.infoDictionary),
                                MockBundle.self,
                                #selector(MockBundle.infoDictionary))
    }
    
    private static func ttsdk_swizzleBundleIdentifier() {
        enableTestMethodSwizzle(Bundle.self,
                                #selector(getter: Bundle.bundleIdentifier),
                                MockBundle.self,
                                #selector(MockBundle.bundleIdentifier))
    }
    
    private static func enableTestMethodSwizzle(_ cls1: AnyClass?, _ selector1: Selector, _ cls2: AnyClass?, _ selector2: Selector) {
        guard let originalMethod = class_getInstanceMethod(cls1, selector1), let newMethod = class_getInstanceMethod(cls2, selector2) else {
            return
        }
        method_exchangeImplementations(originalMethod, newMethod)
    }
}
