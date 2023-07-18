/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit
import TikTokOpenSDKCore

@objc (TTKSDKAuthRequest)
public final class TikTokAuthRequest: NSObject, TikTokBaseRequest {
    let serviceType = TikTokAuthService.self
    
    /// Auth request ID
    public var requestID: String = UUID().uuidString
    
    /// Scopes requested by the third-party app from the TikTok user.
    @objc
    public var scopes: Set<String> = []
    
    /// Used to identify the uniqueness of the request.
    /// It will be returned by TikTok in the response to the third-party app
    @objc
    public var state: String? = nil
    
    /// Whether or not to use web auth
    @objc
    public var isWebAuth: Bool = false
    
    /// Proof Key for Code Exchange (PKCE) class generates a code verifier and code challenge which is used for the OAuth 2.0 protocol.
    @objc
    public let pkce: PKCE = PKCE()
    
    /// The redirect URI is required and used to callback to your application. It should be registered on the Developer Portal.
    /// Your app needs to support associated domain and the redirect URI needs to be a universal link
    /// https://developer.apple.com/documentation/xcode/supporting-associated-domains?language=objc
    @objc
    public var redirectURI: String?

    @objc
    public lazy var service: TikTokRequestResponseHandling = TikTokAuthService()
    
    @objc
    public init(scopes: Set<String>, redirectURI: String) {
        self.scopes = scopes
        self.redirectURI = redirectURI
    }
    
    // MARK: - Public
    /// Send the auth request
    /// - Parameters:
    ///     - completion: Completion handler for the response from TikTok
    /// - Returns: Whether the request was successfully sent
    @objc
    @discardableResult
    public func send(_ completion: ((TikTokBaseResponse) -> Void)? = nil) -> Bool {
        TikTokAPI.add(request: self)
        return service.handleRequest(self, completion: completion)
    }
    
    // MARK: - Private
    deinit {
        TikTokAPI.remove(requestID: self.requestID)
    }
}
