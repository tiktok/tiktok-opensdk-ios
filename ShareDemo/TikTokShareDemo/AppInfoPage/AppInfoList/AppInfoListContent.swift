/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import TikTokOpenSDKCore

let appInfoLIstContent: [AppInfoListSection] = [
    AppInfoListSection(title: "Base App Info", items: [
        AppInfoListItem(
            title: "Custom Client Key",
            subtitle: "Customize your client key",
            isEditable: false,
            cellType: AppInfoListSwitchCell.self,
            propagateChange: { change, viewModel, _ in
                guard let change = change as? Bool else {
                    return
                }
                viewModel.customClientKeyEnabled = change
            },
            setDefault: { $1.default = $0.customClientKeyEnabled }
        ),
        AppInfoListItem(
            title: "Client Key",
            subtitle: "Replace the demo app's client key with your app's. Make sure the bundle ID for your app is added in the developer portal before testing this out.",
            isEditable: false,
            cellType: AppInfoListEditableDisplayCell.self,
            setDefault: { _, item in
                item.default = Bundle.main.infoDictionary?["TikTokClientKey"]
            }
        ),
        AppInfoListItem(
            title: "Is TikTok installed",
            subtitle: "",
            isEditable: false,
            cellType: AppInfoListDisplayCell.self,
            propagateChange: nil,
            setDefault: { _, item in
                item.default = TikTokUtils.TikTokIsInstalled() ? "YES" : "NO"
            }
        )
    ])
]
