/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

let metaInfoListContent = [
    MetaInfoListSection(title: "Media Meta Info", items: [
        MetaInfoListItem(
            title: "Media Count",
            subtitle: "How many media files selected",
            cellType: MetaInfoListDisplayCell.self,
            setDefault: { $1.default = "\($0.media?.count ?? 0)" }
        ),
        MetaInfoListItem(
            title: "Green Screen",
            subtitle: "Use selected media as a green screen background. Only 1 image or 1 video is allowed.",
            cellType: MetaInfoListSwitchCell.self,
            propagate: { change, viewModel, _ in
                viewModel.withGreenScreen = (change as? Bool) ?? false
            },
            default: false
        )
    ])
]
