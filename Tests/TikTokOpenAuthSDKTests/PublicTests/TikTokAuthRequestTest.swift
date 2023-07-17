/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import XCTest
import UIKit

@testable import TikTokOpenSDKCore
@testable import TikTokOpenAuthSDK

class TikTokAuthRequestTest: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    override class func setUp() {
        TikTokTestEnv.setUpEnv()
    }

    func testRequestModifiers() {
        let req = TikTokAuthRequest(scopes: [], redirectURI: "")
        XCTAssert(req.scopes.isEmpty)

        req.scopes.insert("test_permission")
        XCTAssertEqual(req.scopes, Set(["test_permission"]))
    }

    func testSend() {
        var isCalled = false
        let req = TikTokAuthRequest(scopes: ["p1","p2"], redirectURI: "https://www.test.com/test")
        let service = TikTokAuthService(urlOpener: MockURLOpener())
        req.service = service
        req.isWebAuth = false
        XCTAssertTrue(req.send() { res in
            isCalled = true
        })
        XCTAssert(req.service is TikTokAuthService)
        XCTAssert((req.service as! TikTokAuthService).completion != nil)
        let url = URL(string: "https://www.test.com/test?state=&from_platform=tiktokopensdk&request_id=test-request-id&error_code=-2&response_id=test-response-id&error_string=bytebase_cancel_oauth")!
        XCTAssertTrue(TikTokURLHandler.handleOpenURL(url))
        XCTAssertTrue(isCalled)
    }
}
