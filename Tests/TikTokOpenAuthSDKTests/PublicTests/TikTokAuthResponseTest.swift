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
    
    func testEmptyHost() {
        let url = URL(string: "https://")!
        XCTAssertThrowsError(try TikTokAuthResponse(fromURL: url, redirectURI: "https://www.test.com/test")) { error in
            XCTAssertEqual(error as? TikTokResponseError, TikTokResponseError.failToParseURL)
        }
    }
    
    func testNoQueryParams() {
        let url = URL(string: "https://www.test.com/test")!
        XCTAssertThrowsError(try TikTokAuthResponse(fromURL: url, redirectURI: "https://www.test.com/test")) { error in
            XCTAssertEqual(error as? TikTokResponseError, TikTokResponseError.failToParseURL)
        }
    }
    
    func testWrongDomain() {
        let url = URL(string: "https://www.incorrecttest.com/test?from_platform=tiktokopensdk&code=test-auth-code&request_id=test-request-id&error_code=0&response_id=test-response-id&state=test-state")!
        XCTAssertThrowsError(try TikTokAuthResponse(fromURL: url, redirectURI: "https://www.test.com/test")) { error in
            XCTAssertEqual(error as? TikTokResponseError, TikTokResponseError.invalidRedirectURI)
        }
    }
    
    func testSuccess() {
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
}
