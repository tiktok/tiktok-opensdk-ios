/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import XCTest
@testable import TikTokOpenSDKCore
@testable import TikTokOpenAuthSDK

class TikTokURLHandlerTest: XCTestCase {
    override class func setUp() {
        TikTokTestEnv.setUpEnv()
    }

    func testHandleAuthResponseURL_success() {
        let authRequest = TikTokAuthRequest(scopes: ["p1","p2"], redirectURI: "https://www.test.com/test")
        let serv = TikTokAuthService(urlOpener: MockURLOpener())
        authRequest.service = serv
        let callbackExpectation = XCTestExpectation(description: "Expect callback")
        authRequest.send { response in
            callbackExpectation.fulfill()
        }
        let url = URL(string: "https://www.test.com/test?state=&from_platform=tiktokopensdk&request_id=test-request-id&error_code=-2&response_id=test-response-id&error_string=cancel_oauth")!
        XCTAssertEqual(url.host, "www.test.com")
        XCTAssertTrue(TikTokURLHandler.handleOpenURL(url))
        wait(for: [callbackExpectation], timeout: 1)
    }
    
    func testHandleAuthResponseURL_invalidRedirectURI() {
        let authRequest = TikTokAuthRequest(scopes: ["p1","p2"], redirectURI: "https://www.test.com/test")
        let serv = TikTokAuthService(urlOpener: MockURLOpener())
        authRequest.service = serv
        let callbackExpectation = XCTestExpectation(description: "Expect callback")
        authRequest.send { response in
            callbackExpectation.fulfill()
        }
        let url = URL(string: "https://www.incorrecttest.com/test?state=&from_platform=tiktokopensdk&request_id=test-request-id&error_code=-2&response_id=test-response-id&error_string=bytebase_cancel_oauth")!
        XCTAssertEqual(url.host, "www.incorrecttest.com")
        XCTAssertFalse(TikTokURLHandler.handleOpenURL(url))
        let result = XCTWaiter.wait(for: [callbackExpectation], timeout: 1.0)
        XCTAssertEqual(result, .timedOut, "Expectation was fulfilled, but it shouldn't have been.")
    }
}
