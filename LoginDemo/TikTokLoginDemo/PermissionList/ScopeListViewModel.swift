/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import TikTokOpenSDKCore
import TikTokOpenAuthSDK

class ScopeListViewModel: ListViewModel {
    public var scopes: Set<String> = []
    public var alwaysInWeb: Bool = false

    public func toAuthRequest() -> TikTokAuthRequest {
        let req = TikTokAuthRequest(scopes: scopes, redirectURI: "https://open-api.tiktok.com/auth")
        req.isWebAuth = alwaysInWeb
        return req
    }

}
