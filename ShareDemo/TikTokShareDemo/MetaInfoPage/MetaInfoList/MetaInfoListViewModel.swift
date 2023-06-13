/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import TikTokOpenSDKCore
import TikTokOpenShareSDK

class MetaInfoListViewModel: ListViewModel {
    var customClientKey: String?
    var callerUrlScheme: String?
    var shareFormat: TikTokShareFormatType = .normal
    var withGreenScreen: Bool = false {
        didSet {
            if withGreenScreen {
                shareFormat = .greenScreen
            } else {
                shareFormat = .normal
            }
        }
    }

    var media: [String]?
    var mediaType: TikTokShareMediaType = .image

    func toRequest() -> TikTokShareRequest {
        let ret = TikTokShareRequest(localIdentifiers: media ?? [], mediaType: mediaType, redirectURI: "https://open-api.tiktok.com/share")
        if let clientKey = customClientKey, let callerUrlScheme = callerUrlScheme {
            ret.customConfig = TikTokShareRequest.CustomConfiguration(clientKey: clientKey, callerUrlScheme: callerUrlScheme)
        }
        ret.shareFormat = shareFormat
        return ret
    }
}
