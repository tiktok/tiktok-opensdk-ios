/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import XCTest
@testable import TikTokOpenSDKCore
@testable import TikTokOpenShareSDK

class TikTokShareRequestTest: XCTestCase {
    
    override class func setUp() {
        TikTokTestEnv.setUpEnv()
    }
    
    func testSend_fail() {
        var isCalled = false
        let shareRequest = TikTokShareRequest(localIdentifiers: [], mediaType: .video, redirectURI: "")
        let shareService = TikTokShareService(urlOpener: MockURLOpener())
        shareRequest.service = shareService
        XCTAssertFalse(shareRequest.send() { res in
            isCalled = true
        })
        XCTAssert(shareRequest.service is TikTokShareService)
        XCTAssert((shareRequest.service as! TikTokShareService).completion == nil)
        XCTAssertFalse(isCalled)
    }
    
    func testSend_success() {
        var isCalled = false
        let shareRequest = TikTokShareRequest(localIdentifiers: ["id1","id2"], mediaType: .video, redirectURI: "https://www.test.com/test")
        let shareService = TikTokShareService(urlOpener: MockURLOpener())
        shareRequest.service = shareService
        XCTAssertTrue(shareRequest.send() { res in
            isCalled = true
        })
        XCTAssert(shareRequest.service is TikTokShareService)
        XCTAssert((shareRequest.service as! TikTokShareService).completion != nil)
        let url = URL(string: "https://www.test.com/test?state=&from_platform=tiktoksharesdk&request_id=test-request-id&error_code=0&response_id=test-response-id")!
        XCTAssertTrue(TikTokURLHandler.handleOpenURL(url))
        XCTAssertTrue(isCalled)
    }
    
}
