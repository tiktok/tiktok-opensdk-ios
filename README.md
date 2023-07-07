# TikTok OpenSDK for iOS

## Introduction

TikTok OpenSDK is a framework that enables your users to log into your app with their TikTok accounts and share images and videos to TikTok. This SDK is available for download through CocoaPods.

## Getting Started

Minimum iOS version is 11.0 and minimum XCode version is 9.0. See [iOS Quickstart](https://developers.tiktok.com/doc/mobile-sdk-ios-quickstart/) for more details.

### Developer Portal Application

Sign up for a developer account in our [Developer Portal](https://developers.tiktok.com/login/). Upon application approval, the Developer Portal will provide you with a `Client Key` and `Client Secret`. See how to register your app [here](https://developers.tiktok.com/doc/getting-started-create-an-app/).

### Install the SDK

1. Add the following to your Podfile
```ruby
pod 'TikTokOpenSDKCore'
pod 'TikTokOpenAuthSDK'
pod 'TikTokOpenShareSDK'
```
2. Run `pod install --repo-update`

### Configure Your XCode Project

1. Open your Info.plist file and add/update the following keys.
    - Add the following values to `LSApplicationQueriesSchemes`:
        - `tiktokopensdk` for Login Kit
        - `tiktoksharesdk` for Share Kit
        - `snssdk1233` and `snssdk1180` to check if TikTok is installed on your device.
    - Add the key `TikTokClientKey` with your apps `Client Key` as the value.
    - Add your apps `Client Key` to `CFBundleURLSchemes`.
```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>tiktokopensdk</string>
    <string>tiktoksharesdk</string>
    <string>snssdk1180</string>
    <string>snssdk1233</string>
</array>
<key>TikTokClientKey</key>
<string>$TikTokClientKey</string>
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>$TikTokClientKey</string>
    </array>
  </dict>
</array>
```
2. Add the following code to your app's AppDelegate:
```swift
import TikTokOpenSDKCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ app: UIApplication,open url: URL, 
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if (TikTokURLHandler.handleOpenURL(url)) {
            return true
        }
        return false
    }
        
    func application(_ application: UIApplication, 
                     continue userActivity: NSUserActivity, 
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if (TikTokURLHandler.handleOpenURL(userActivity.webpageURL)) {
            return true
        }
        return false
    }
    
}
```
3. Add the following code to your app's SceneDelegate file if it has one:
```swift
import TikTokOpenSDKCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    func scene(_ scene: UIScene, 
               openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if (TikTokURLHandler.handleOpenURL(URLContexts.first?.url)) {
            return
        }
    }

}
```

## Login Kit Usage

Login Kit functionality depends on the `TikTokOpenSDKCore` and `TikTokOpenAuthSDK` pods, so be sure to add these to your podfile. The following code snippet shows how to create an authorization request and handle the response. See [Login Kit for iOS](https://developers.tiktok.com/doc/login-kit-ios-quickstart/) for more details.
```swift
import TikTokOpenAuthSDK

let authRequest = TikTokAuthRequest(scopes: ["user.info.basic"], redirectURI: "https://www.example.com/path")
authRequest.send { response in
    let authResponse = response as? TikTokAuthResponse else { return }
    if authResponse.errorCode == .noError {
        print("Auth code: \(authResponse.code)")
    } else {
       print("Authorization Failed! 
             Error: \(authResponse.error ?? "") 
             Error Description: \(authResponse.errorDescription ?? ""))
    }
}
```
Your app is responsible for maintaining a strong reference to the request in order to receive the response callback. You can discard it when you are done with the response.

## Share Kit Usage

Share Kit functionality depends on the `TikTokOpenSDKCore` and `TikTokOpenShareSDK` pods, so be sure to add these to your podfile. The following code snippet shows how to create a share request and handle the response. See [Share Kit for iOS](https://developers.tiktok.com/doc/share-kit-ios-quickstart-v2/) for more details.
```swift
import TikTokOpenShareSDK

let shareRequest = TikTokShareRequest(localIdentifiers: [...], mediaType: .video, redirectURI: "https://www.example.com/path")
shareRequest.send { response in
    let shareResponse = response as? TikTokShareResponse else { return }
    if shareResponse.errorCode == .noError {
        print("Share succeeded!")
    } else {
        print("Share Failed! 
               Error Code: \(shareResponse.errorCode.rawValue) 
               Error Message: \(shareResponse.errorMessage ?? "") 
               Share State: \(shareResponse.shareState)")
    }
}
```
Your app is responsible for maintaining a strong reference to the request in order to receive the response callback. You can discard it when you are done with the response.

## Demos

Minimum iOS version for these demo apps is iOS 11.0.

1. Find a demo app for Login Kit or Share Kit under `/LoginDemo` or `/ShareDemo` respectively, and download it.
2. `cd` into the directory and give it a `pod install`.
3. `open TikTokXXXDemo.xcworkspace` and run the project to view the kit in action.

## License

This source code is licensed under the license found in the LICENSE file in the root directory of this source tree.

