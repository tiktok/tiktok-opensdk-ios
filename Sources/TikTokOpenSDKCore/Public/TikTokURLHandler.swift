/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

@objc (TTKSDKURLHandler)
public final class TikTokURLHandler: NSObject {
    // MARK: - Public
    /// Handle the url sent back from TikTok.
    /// Call this function in your appDelegate's `application(_:open:options:)` method
    /// - Parameters:
    ///     - url: The respnose universal URL from TikTok
    @objc
    static public func handleOpenURL(_ url: URL?) -> Bool {
        guard let url = url, let _ = url.host else { return false }
        return TikTokAPI.handle(url: url)
    }
}
