/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import XCTest
@testable import TikTokOpenSDKCore
@testable import TikTokOpenShareSDK

class TikTokShareResponseTest: XCTestCase {
    
    override class func setUp() {
        TikTokTestEnv.setUpEnv()
    }
    
    func testEmptyHost() {
        let url = URL(string: "https://")!
        XCTAssertThrowsError(try TikTokShareResponse(fromURL: url, redirectURI: "https://www.test.com/test")) { error in
            XCTAssertEqual(error as? TikTokResponseError, TikTokResponseError.failToParseURL)
        }
    }
    
    func testNoQueryParams() {
        let url = URL(string: "https://www.test.com/test")!
        XCTAssertThrowsError(try TikTokShareResponse(fromURL: url, redirectURI: "https://www.test.com/test")) { error in
            XCTAssertEqual(error as? TikTokResponseError, TikTokResponseError.failToParseURL)
        }
    }
    
    func testUnsupportedScheme() {
        let url = URL(string: "https://www.incorrecttest.com/test?from_platform=invalid-scheme&code=test-auth-code&request_id=test-request-id&error_code=0&response_id=test-response-id&state=test-state")!
        XCTAssertThrowsError(try TikTokShareResponse(fromURL: url, redirectURI: "https://www.test.com/test")) { error in
            XCTAssertEqual(error as? TikTokResponseError, TikTokResponseError.unsupportedScheme)
        }
    }
    
    func testWrongDomain() {
        let url = URL(string: "https://www.incorrecttest.com/test?from_platform=tiktoksharesdk&code=test-auth-code&request_id=test-request-id&error_code=0&response_id=test-response-id&state=test-state")!
        XCTAssertThrowsError(try TikTokShareResponse(fromURL: url, redirectURI: "https://www.test.com/test")) { error in
            XCTAssertEqual(error as? TikTokResponseError, TikTokResponseError.invalidRedirectURI)
        }
    }
    
    func testSuccess() {
        let url = URL(string: "https://www.test.com/test?from_platform=tiktoksharesdk&request_id=test_req_id&response_id=test_res_id&error_code=0&error_description=error_description&state=state&share_state=20000")!
        var res: TikTokShareResponse? = nil
        XCTAssertNoThrow(try res = TikTokShareResponse(fromURL: url, redirectURI: "https://www.test.com/test"))
        XCTAssertNotNil(res)
        XCTAssertEqual(res?.responseID, "test_res_id")
        XCTAssertEqual(res?.requestID, "test_req_id")
        XCTAssertEqual(res?.errorDescription, "error_description")
        XCTAssertEqual(res?.errorCode.rawValue, 0)
        XCTAssertEqual(res?.shareState.rawValue, 20000)
        XCTAssertEqual(res?.state, "state")
    }
    
}
