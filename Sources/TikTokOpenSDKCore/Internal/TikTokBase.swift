/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

public typealias TikTokRequestResponseHandling = TikTokRequestHandling & TikTokResponseHandling

public enum TikTokResponseError: Error {
    case failToParseURL
    case invalidRedirectURI
}

@objc(TTKSDKBaseResponse)
public protocol TikTokBaseResponse {
    var responseID: String? { get set }
}

@objc(TTKSDKBaseRequest)
public protocol TikTokBaseRequest {
    var requestID: String { get set }
    
    var redirectURI: String? { get set }
    
    var service: TikTokRequestResponseHandling { get }
    
    @discardableResult
    func send(_ completion: ((TikTokBaseResponse) -> Void)?) -> Bool
}
