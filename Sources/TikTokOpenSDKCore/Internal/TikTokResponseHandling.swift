/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

@objc(TTKSDKResponseHandling)
public protocol TikTokResponseHandling {
    /// Handle the response from TikTok app with a universal link
    func handleResponseURL(url: URL) -> Bool
}
