/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import XCTest

@testable import TikTokOpenAuthSDK
@testable import TikTokOpenSDKCore

class TikTokAuthResponseTest: XCTestCase {
    
    override class func setUp() {
        TikTokTestEnv.setUpEnv()
    }
    
    func testEmptyHost() {
        let url = URL(string: "https://")!
        XCTAssertThrowsError(try TikTokAuthResponse(fromURL: url, redirectURI: "https://www.test.com/test")) { error in
            XCTAssertEqual(error as? TikTokResponseError, TikTokResponseError.failToParseURL)
        }
    }
    
    func testNoQueryParams_native() {
        let url = URL(string: "https://www.test.com/test")!
        XCTAssertThrowsError(try TikTokAuthResponse(fromURL: url, redirectURI: "https://www.test.com/test")) { error in
            XCTAssertEqual(error as? TikTokResponseError, TikTokResponseError.failToParseURL)
        }
    }
    
    func testWrongDomain_native() {
        let url = URL(string: "https://www.incorrecttest.com/test?from_platform=tiktokopensdk&code=test-auth-code&request_id=test-request-id&error_code=0&response_id=test-response-id&state=test-state")!
        XCTAssertThrowsError(try TikTokAuthResponse(fromURL: url, redirectURI: "https://www.test.com/test")) { error in
            XCTAssertEqual(error as? TikTokResponseError, TikTokResponseError.invalidRedirectURI)
        }
    }
    
    func testSuccess_native() {
        let url = URL(string: "https://www.test.com/test?from_platform=tiktokopensdk&code=test-auth-code&request_id=test-request-id&error_code=0&response_id=test-response-id&state=test-state")!
        var res: TikTokAuthResponse? = nil
        XCTAssertNoThrow(res = try TikTokAuthResponse(fromURL: url, redirectURI: "https://www.test.com/test"))
        XCTAssertNotNil(res)
        XCTAssertEqual(res!.errorCode, TikTokAuthResponseErrorCode.noError)
        XCTAssertEqual(res!.authCode, "test-auth-code")
        XCTAssertEqual(res!.requestID, "test-request-id")
        XCTAssertEqual(res!.responseID, "test-response-id")
        XCTAssertEqual(res!.state, "test-state")   
    }
    
    func testEmptyHost_web() {
        let url = URL(string: "aaaa://")!
        XCTAssertThrowsError(try TikTokAuthResponse(fromURL: url, redirectURI: "https://www.test.com/test", fromWeb: true)) { error in
            XCTAssertEqual(error as? TikTokResponseError, TikTokResponseError.failToParseURL)
        }
    }
    
    func testNoQueryParams_web() {
        let url = URL(string: "aaaa://response.bridge.tiktok.com/oauth")!
        XCTAssertThrowsError(try TikTokAuthResponse(fromURL: url, redirectURI: "https://www.test.com/test", fromWeb: true)) { error in
            XCTAssertEqual(error as? TikTokResponseError, TikTokResponseError.failToParseURL)
        }
    }
    
    func testSuccess_web() {
        let url = URL(string: "aaaa://response.bridge.tiktok.com/oauth?from_platform=tiktokopensdk&code=test-auth-code&request_id=test-request-id&error_code=0&response_id=test-response-id&state=test-state")!
        var res: TikTokAuthResponse? = nil
        XCTAssertNoThrow(res = try TikTokAuthResponse(fromURL: url, redirectURI: "https://www.test.com/test", fromWeb: true))
        XCTAssertNotNil(res)
        XCTAssertEqual(res!.errorCode, TikTokAuthResponseErrorCode.noError)
        XCTAssertEqual(res!.authCode, "test-auth-code")
        XCTAssertEqual(res!.requestID, "test-request-id")
        XCTAssertEqual(res!.responseID, "test-response-id")
        XCTAssertEqual(res!.state, "test-state")
    }
}
