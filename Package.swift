// swift-tools-version:5.8
import PackageDescription

let package = Package(
    name: "tiktok-opensdk-ios",
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
