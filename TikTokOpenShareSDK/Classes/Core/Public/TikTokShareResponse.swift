/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import TikTokOpenSDKCore

/// The result type of this sharing
@objc (TTKSDKShareResponseState)
public enum TikTokShareResponseState: Int {
    /// Success
    case success = 20000
    /// unknown, maybe because the SDK version is too low
    case unknownError = 20001
    /// Param parsing error
    case paramInvalid = 20002
    /// Permission not granted
    case sharePermissionDenied = 20003
    /// User didn't not log in
    case userNotLogin = 20004
    /// No album permissions
    case noPhotoLibraryPermission = 20005
    /// Network issue
    case networkError = 20006
    /// Video length doesn't meet TikTok requrements
    case videoTimeLimitError = 20007
    /// Photo resolution doesn't meet TikTok requirements
    case photoResolutionError = 20008
    /// Timestamp checking failed
    case timeStampError = 20009
    /// Processing photo resources failed
    case handleMediaError = 20010
    /// Video resolution doesn't meet TikTok Requirements
    case videoResolutionError = 20011
    /// Unsupported video format
    case videoFormatError = 20012
    /// Sharing canceled by user
    case cancelled = 20013
    /// Another video is being uploaded
    case haveUploadedTask = 20014
    /// User saved the shared content as a draft
    case saveAsDraft = 20015
    /// Posting shared contents failed
    case publishFaild = 20016
    /// Downloading media from iCloud failed
    case mediaInICloudError = 21001
    /// Internal params parsing error
    case paramsParsingError = 21002
    /// Media resources do not exist
    case getMediaError = 21003
}


@objc (TTKSDKShareResponseErrorCode)
public enum TikTokShareResponseErrorCode: Int {
    case noError = 0
    case common = -1
    case cancelled = -2
    case failed = -3
    case denied = -4
    case unsupported = -5
    case missingParams = 10005
    case unknown = 100000
}

@objc (TTKSDKShareResponse)
public class TikTokShareResponse: NSObject, TikTokBaseResponse {
    /// Response ID
    @objc
    public var responseID: String?
    
    /// Request ID
    @objc
    public var requestID: String?
    
    /// Request state
    @objc
    public var state: String?
    
    /// Response result state
    @objc
    public var shareState: TikTokShareResponseState = .success
    
    /// Error description
    @objc
    public var errorDescription: String?
    
    /// Response error code
    @objc
    public var errorCode: TikTokShareResponseErrorCode = .noError
    
    // MARK: - Public
    /// Initialize a share response from a URL
    /// - Parameters:
    ///     - url: the complete url with query parameters that TikTok sends back to your app
    ///     - redirectURI: the redirect URI used to callback to your app. Used to verify url.
    /// - Throws:a TikTokResponseError that can occur if the url is malformed or the redirectURI is invalid
    @objc
    public init(fromURL url: URL, redirectURI: String) throws {
        guard let comps = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw TikTokResponseError.failToParseURL
        }
        guard let dict = comps.queryItems?.reduce(into: [String: String](), {
            $0[$1.name] = $1.value
        }) else {
            throw TikTokResponseError.failToParseURL
        }
        
        guard url.absoluteString.hasPrefix(redirectURI) else {
            throw TikTokResponseError.invalidRedirectURI
        }
        
        requestID        = dict["request_id"]
        responseID       = dict["response_id"]
        errorDescription = dict["error_description"]
        state            = dict["state"]
        
        if let state = dict["share_state"], let stateInt = Int(state) {
            shareState = TikTokShareResponseState(rawValue:stateInt) ?? .unknownError
        }
        if let error = (dict["error_code"] ?? dict["errCode"]), let errorInt = Int(error) {
            errorCode = TikTokShareResponseErrorCode(rawValue: errorInt) ?? .unknown
        }
    }
}
