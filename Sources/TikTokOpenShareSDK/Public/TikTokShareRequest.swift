/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import TikTokOpenSDKCore
import UIKit

/// The type of media shared to TikTok
@objc (TTKSDKShareMediaType)
public enum TikTokShareMediaType: Int {
    case image = 0
    case video
}

/// Sharing the video as a content or as some resources used in editting
@objc (TTKSDKShareFormatType)
public enum TikTokShareFormatType: Int {
    case normal = 0
    case greenScreen
}

@objc (TTKSDKShareRequest)
public class TikTokShareRequest: NSObject, TikTokBaseRequest {
    @objc(TikTokShareCustomConfiguration)
    public class CustomConfiguration: NSObject {
        let clientKey: String
        let callerUrlScheme: String
        public init(clientKey: String, callerUrlScheme: String) {
            self.clientKey = clientKey
            self.callerUrlScheme = callerUrlScheme
            super.init()
        }
    }
    
    /// Share request ID
    @objc
    public var requestID: String = UUID().uuidString
    
    /**
       The local identifier of the video or image shared by the your application to Open Platform in the **Photo Album**. The content must be all images or videos.

       - The aspect ratio of the images or videos should between: [1/2.2, 2.2]
       - If mediaType is Image:
        - The number of images should be more than one and up to 12.
       - If mediaType is Video:
        - Total video duration should be longer than 3 seconds.
        - No more than 12 videos can be shared
       - Video with brand logo or watermark will lead to video deleted or account banned. Make sure your applications share contents without watermark.
     */
    @objc
    public var localIdentifiers: [String]?
    
    /// The redirect URI is required and used to callback to your application. It should be registered on the Developer Portal.
    /// Your app needs to support associated domain and the redirect URI needs to be a universal link
    /// https://developer.apple.com/documentation/xcode/supporting-associated-domains?language=objc
    @objc
    public var redirectURI: String?
    

    /// Pick a share format. Setting shareFormat to TikTokShareFormatGreenScreen will set a single video or a single photo as a background for the green screen effect in TikTok. Default is TikTokShareFormatNormal.
    @objc
    public var shareFormat: TikTokShareFormatType = .normal
    
    /// Media type
    @objc
    public var mediaType: TikTokShareMediaType = .image
    
    /// Used to identify the uniqueness of the request.
    /// It will be returned by TikTok in the response to the third-party app
    @objc
    public var state: String? = nil
    
    /// If hostViewController is nil, will use top view controller
    @objc
    public weak var hostViewController: UIViewController?
    
    /// Custom configuration for client key and caller url scheme.
    /// No need to provide it for regular cases if client key is provided in info.plist with key `TikTokClientKey`
    @objc
    public var customConfig: CustomConfiguration? = nil
    
    @objc
    public lazy var service: TikTokRequestResponseHandling = TikTokShareService()
    
    @objc
    public init(localIdentifiers: [String], mediaType: TikTokShareMediaType, redirectURI: String) {
        self.localIdentifiers = localIdentifiers
        self.redirectURI = redirectURI
        self.mediaType = mediaType
    }
    
    // MARK: - Public
    @objc
    @discardableResult
    public func send(_ completion: ((TikTokBaseResponse) -> Void)? = nil) -> Bool {
        guard isValid else { return false }
        TikTokAPI.add(request: self)
        return service.handleRequest(self, completion: completion)
    }
    
    // MARK: - Private
    private var isValid: Bool {
        guard let localIdentifiers = localIdentifiers, localIdentifiers.count > 0 else {
            return false
        }
        
        return true
    }
    
    deinit {
        TikTokAPI.remove(requestID: self.requestID)
    }
}
