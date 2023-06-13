/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import XCTest
@testable import TikTokOpenSDKCore
@testable import TikTokOpenAuthSDK

class TikTokAuthServiceTest: XCTestCase {
    override class func setUp() {
        TikTokTestEnv.setUpEnv()
    }

    func testBuildOpenURL_empty() {
        let req = TikTokAuthRequest(scopes: [], redirectURI: "")
        let url = TikTokAuthService.buildOpenURL(from: req)
        XCTAssertNotNil(url)
        let comp = URLComponents(url: url!, resolvingAgainstBaseURL: false)
        XCTAssertEqual(comp?.host, "www.tiktok.com")
        XCTAssertEqual(comp?.path, "/opensdk/oauth/")
    }
    
    func testBuildOpenURL_success() {
        let req = TikTokAuthRequest(scopes: [], redirectURI: "")
        req.scopes.insert("p1")
        req.scopes.insert("p2")
        req.requestID = "test-request-id"
        req.state = "test-state"
        let url = TikTokAuthService.buildOpenURL(from: req)
        XCTAssertNotNil(url)
        XCTAssertEqual(url!.host, "www.tiktok.com")
        XCTAssertEqual(url!.scheme, "https")
        XCTAssertEqual(url!.lastPathComponent, "oauth")
        let comps = URLComponents(url: url!, resolvingAgainstBaseURL: false)!
        let dict: [String: String] = comps.queryItems!.reduce( into: [String:String](), { $0[$1.name] = $1.value })
        XCTAssertEqual(dict["state"], "test-state")
        // bundle id is org.cocoapods.AppHost-TikTokOpenAuthSDK-Unit-Tests
        XCTAssertEqual(dict["app_identity"], "2e753650bcb5e242a96020e569d27fdb2c7fde7cdc5d8e816e71a887bd4afa7e51065337f438b2b2059bfbbb3859889b6d6e594657622adbb715cfba9f9f40ec")
        XCTAssertEqual(dict["request_id"], "test-request-id")
        XCTAssertEqual(dict["api_version"], TikTokInfo.currentVersion)
        XCTAssertEqual(dict["device_platform"], "iphone")
        XCTAssertEqual(dict["consumer_key"], "aaaa")
        let perm = dict["permissions"]
        let permCheck = perm == "p1,p2" || perm == "p2,p1"
        XCTAssertTrue(permCheck)
    }
    
    func testHandleRequest_success() {
        let redirectURI = "https://www.test.com/test"
        let req = TikTokAuthRequest(scopes: ["p1","p2"], redirectURI: redirectURI)
        req.requestID = "test-request-id"
        req.state = "test-state"
        let serv = TikTokAuthService()
        let tiktokExpectation = XCTestExpectation(description: "Expect to open TikTok")
        
        let ret = serv.handleRequest(req, completion: { _ in
            tiktokExpectation.fulfill()
        })
        XCTAssertEqual(serv.redirectURI, redirectURI)
        XCTAssertNotNil(serv.completion)
        let url = URL(string: "https://www.test.com/test?from_platform=tiktokopensdk&code=test-auth-code&request_id=test-request-id&error_code=0&response_id=test-response-id&state=test-state")!
        do {
            try serv.completion!(TikTokAuthResponse(fromURL: url, redirectURI: redirectURI))
        } catch {
            XCTFail("Should not throw error")
        }
        wait(for: [tiktokExpectation], timeout: 1)
        XCTAssertTrue(ret)
    }
    
    func testHandleResponse_invalidRedirectURI() {
        let redirectURI = "https://www.test.com/test"
        let req = TikTokAuthRequest(scopes: ["p1","p2"], redirectURI: redirectURI)
        req.requestID = "test-request-id"
        req.state = "test-state"
        let serv = TikTokAuthService()
        let tiktokExpectation = XCTestExpectation(description: "Expect to open TikTok")
        
        let ret = serv.handleRequest(req, completion: { _ in
            tiktokExpectation.fulfill()
        })
        XCTAssertTrue(ret)
        XCTAssertEqual(serv.redirectURI, redirectURI)
        XCTAssertNotNil(serv.completion)
        let url = URL(string: "https://www.incorrecttest.com/test?from_platform=tiktokopensdk&code=test-auth-code&request_id=test-request-id&error_code=0&response_id=test-response-id&state=test-state")!
        XCTAssertThrowsError(try serv.completion!(TikTokAuthResponse(fromURL: url, redirectURI: redirectURI))) { error in
            XCTAssertEqual(error as? TikTokResponseError, TikTokResponseError.invalidRedirectURI)
        }
        let result = XCTWaiter.wait(for: [tiktokExpectation], timeout: 1.0)
        XCTAssertEqual(result, .timedOut, "Expectation was fulfilled, but it shouldn't have been.")
    }
    
    func testHandleResponse_failWithEmptyClosure() {
        let url = URL(string: "https://www.test.com/test?from_platform=tiktokopensdk&code=test-auth-code&request_id=test-request-id&error_code=0&response_id=test-response-id&state=test-state")!
        let serv = TikTokAuthService()
        XCTAssertFalse(serv.handleResponseURL(url: url))
    }
}
