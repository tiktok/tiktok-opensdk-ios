/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

@objc(TTKSDKRequestHandling)
public protocol TikTokRequestHandling {
    /// Service-specific method to construct an URL to TikTok app
    static func buildOpenURL(from request: TikTokBaseRequest) -> URL?
    
    /// Handle the request with callbacks when TikTok app is launched and the task is completed with a response
    func handleRequest(
        _ request: TikTokBaseRequest,
        completion: ((TikTokBaseResponse) -> Void)?
    ) -> Bool
}
