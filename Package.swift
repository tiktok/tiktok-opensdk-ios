// swift-tools-version:5.5
/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import PackageDescription

let package = Package(
    name: "TikTokOpenSDK",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "TikTokOpenAuthSDK",
            targets: ["TikTokOpenAuthSDK"]
        ),
        .library(
            name: "TikTokOpenSDKCore",
            targets: ["TikTokOpenSDKCore"]
        ),
        .library(
            name: "TikTokOpenShareSDK",
            targets: ["TikTokOpenShareSDK"]
        )
    ],
    targets: [
        .target(
            name: "TikTokOpenAuthSDK",
            dependencies: ["TikTokOpenSDKCore"]
        ),
        .testTarget(
            name: "TikTokOpenAuthSDKTests",
            dependencies: ["TikTokOpenAuthSDK"]
        ),
        .target(
            name: "TikTokOpenSDKCore"
        ),
        .target(
            name: "TikTokOpenShareSDK",
            dependencies: ["TikTokOpenSDKCore"]
        ),
        .testTarget(
            name: "TikTokOpenShareSDKTests",
            dependencies: ["TikTokOpenShareSDK"]
        )
    ]
)
