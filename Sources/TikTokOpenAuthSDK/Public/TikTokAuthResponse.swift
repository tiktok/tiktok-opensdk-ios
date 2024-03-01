/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import TikTokOpenSDKCore

@objc (TTKSDKAuthResponseErrorCode)
public enum TikTokAuthResponseErrorCode: Int {
    case noError = 0
    case common = -1
    case cancelled = -2
    case failed = -3
    case denied = -4
    case unsupported = -5
    case webviewError = -8
    case missingParams = 10005
    case unknown = 100000
}

@objc (TTKSDKAuthResponse)
public class TikTokAuthResponse: NSObject, TikTokBaseResponse {
    /// Auth response ID
    @objc
    public var responseID: String?
    
    /// Auth request ID
    @objc
    public let requestID: String?
    
    /// Authorization error description
    @objc
    public let errorDescription: String?
    
    /// OAuth 2.0 error
    @objc
    public let error: String?
    
    /// Authorization code
    @objc
    public let authCode: String?
    
    /// You apply for certain scopes to Open Platform, and finally return to the third-party application based on the actual authorization result after the App authorization is completed.
    @objc
    public var errorCode: TikTokAuthResponseErrorCode = .noError
    
    /// State can be used to identify the uniqueness of the request, and finally returned by Open Platform when jumping back to a third-party program
    @objc
    public var state: String? = nil
    
    /// The users agree to give your applications permission, if the authorization is successful, all necessary permissions checked by the user;
    @objc public var grantedPermissions: Set<String>? = nil
    
    // MARK: - Public
    /// Initialize an auth response from a redirect URL
    /// - Parameters:
    ///     - url: the complete url with query parameters that TikTok sends back to your app
    ///     - redirectURI: the redirect URI used to callback to your app. Used to verify url.
    ///     - fromWeb: if the response is coming from TikTok or SFSafariViewController
    /// - Throws:a TikTokResponseError that can occur if the url is malformed or the redirectURI is invalid
    @objc
    public init(fromURL url: URL, redirectURI: String, fromWeb: Bool) throws {
        guard let comps = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw TikTokResponseError.failToParseURL
        }
        guard let dict = comps.queryItems?.reduce(into: [String: String](), {
            $0[$1.name] = $1.value
        }) else {
            throw TikTokResponseError.failToParseURL
        }
        if fromWeb {
            guard url.absoluteString.hasPrefix(TikTokInfo.webAuthRedirectURI) else {
                throw TikTokResponseError.invalidRedirectURI
            }
        } else {
            guard url.absoluteString.hasPrefix(redirectURI) else {
                throw TikTokResponseError.invalidRedirectURI
            }
        }
        
        requestID        = dict["request_id"]
        responseID       = dict["response_id"]
        errorDescription = dict["error_description"]
        error            = dict["error"]
        authCode         = dict["code"]
        state            = dict["state"]
        
        if let _code = dict["error_code"] ?? dict["errCode"] {
            errorCode = TikTokAuthResponseErrorCode(rawValue: Int(_code) ?? -5) ?? .unknown
        } else {
            errorCode = (authCode?.isEmpty ?? true) ? .common : .noError
        }
        
        if let _permissions = dict["additionalPermissions"] ?? dict["scopes"] {
            grantedPermissions = Set(_permissions.components(separatedBy: ","))
        }
    }
    
    @objc
    public convenience init(fromURL url: URL, redirectURI: String) throws {
        try self.init(fromURL: url, redirectURI: redirectURI, fromWeb: false)
    }
}
