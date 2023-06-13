/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import XCTest
@testable import TikTokOpenShareSDK

class TikTokShareServiceTest: XCTestCase {
    
    override class func setUp() {
        TikTokTestEnv.setUpEnv()
    }
    
    func testBuildOpenURL_empty() {
        let req = TikTokShareRequest(localIdentifiers: [], mediaType: .video, redirectURI: "https://www.test.com/test")
        let url = TikTokShareService.buildOpenURL(from: req)
        XCTAssertNotNil(url)
        let comp = URLComponents(url: url!, resolvingAgainstBaseURL: false)
        XCTAssertNotNil(comp)
        XCTAssertEqual(comp?.host, "www.tiktok.com")
        XCTAssertEqual(comp?.path, "/opensdk/share/")
    }
    
    func testBuildOpenURL_success() {
        let req = TikTokShareRequest(localIdentifiers: ["1", "2"], mediaType: .video, redirectURI: "https://www.test.com/test")
        req.state = "test-state"
        let url = TikTokShareService.buildOpenURL(from: req)
        XCTAssertNotNil(url)
        let comps = URLComponents(url: url!, resolvingAgainstBaseURL: false)
        XCTAssertNotNil(comps)
        let queries = comps?.queryItems
        XCTAssertNotNil(queries)
        let dict = queries!.reduce(into: [String:String]()){ $0[$1.name] = $1.value }
        XCTAssertNotNil(dict["request_id"])
        XCTAssertNotNil(dict["key"])
        XCTAssertEqual(dict["media_paths"], "1,2")
        XCTAssertEqual(dict["media_type"], String(TikTokShareMediaType.video.rawValue))
        XCTAssertEqual(dict["state"], "test-state")
    }
    
    func testHandleResponseURL_success() {
        let redirectURI = "https://www.test.com/test"
        let shareRequest = TikTokShareRequest(localIdentifiers: [], mediaType: .video, redirectURI: redirectURI)
        let shareService = TikTokShareService()
        let tiktokExpectation = XCTestExpectation(description: "Expect to open TikTok")
        var response: TikTokShareResponse?
        var isExecuted = false
        XCTAssertTrue(shareService.handleRequest(shareRequest, completion: { res in
            isExecuted = true
            response = res as? TikTokShareResponse
            tiktokExpectation.fulfill()
        }))
        let url = URL(string: "https://www.test.com/test?request_id=test_req_id&response_id=test_res_id&error_code=0&error_string=error_string&state=state&share_state=20000&from_platform=tiktoksharesdk")!
        XCTAssertTrue(shareService.handleResponseURL(url: url))
        XCTAssertNotNil(response)
        XCTAssertTrue(isExecuted)
    }
    
    func testHandleResponseURL_invalidRedirectURI() {
        let redirectURI = "https://www.test.com/test"
        let shareRequest = TikTokShareRequest(localIdentifiers: [], mediaType: .video, redirectURI: redirectURI)
        let shareService = TikTokShareService()
        let tiktokExpectation = XCTestExpectation(description: "Expect to open TikTok")
        var response: TikTokShareResponse?
        var isExecuted = false
        XCTAssertTrue(shareService.handleRequest(shareRequest, completion: { res in
            isExecuted = true
            response = res as? TikTokShareResponse
            tiktokExpectation.fulfill()
        }))
        let url = URL(string: "https://www.incorrecttest.com/test?request_id=test_req_id&response_id=test_res_id&error_code=0&error_string=error_string&state=state&share_state=20000&from_platform=tiktoksharesdk")!
        XCTAssertFalse(shareService.handleResponseURL(url: url))
        XCTAssertNil(response)
        XCTAssertFalse(isExecuted)
        let result = XCTWaiter.wait(for: [tiktokExpectation], timeout: 1.0)
        XCTAssertEqual(result, .timedOut, "Expectation was fulfilled, but it shouldn't have been.")
    }
}
