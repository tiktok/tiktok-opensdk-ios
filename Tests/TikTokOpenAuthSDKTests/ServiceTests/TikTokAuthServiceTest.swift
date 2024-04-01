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
    
    func testBuildOpenURL_webAuth_empty() {
        let authReq = TikTokAuthRequest(scopes: [], redirectURI: "")
        authReq.isWebAuth = true
        let url = authReq.service.buildOpenURL(from: authReq)
        let comp = URLComponents(url: url!, resolvingAgainstBaseURL: false)
        XCTAssertEqual(comp?.host, "www.tiktok.com")
        XCTAssertEqual(comp?.path, "/v2/auth/authorize/")
    }

    func testBuildOpenURL_native_empty() {
        let authReq = TikTokAuthRequest(scopes: [], redirectURI: "")
        authReq.service = TikTokAuthService(urlOpener: MockURLOpener())
        let url = authReq.service.buildOpenURL(from: authReq)
        XCTAssertNotNil(url)
        let comp = URLComponents(url: url!, resolvingAgainstBaseURL: false)
        XCTAssertEqual(comp?.host, "www.tiktok.com")
        XCTAssertEqual(comp?.path, "/opensdk/oauth/")
    }
    
    func testBuildOpenURL_webAuth_success() {
        let authReq = TikTokAuthRequest(scopes: ["p1","p2"], redirectURI: "https://www.test.com/test")
        authReq.requestID = "test-request-id"
        authReq.state = "test-state"
        authReq.isWebAuth = true
        let url = authReq.service.buildOpenURL(from: authReq)
        XCTAssertNotNil(url)
        XCTAssertEqual(url!.scheme, "https")
        XCTAssertEqual(url!.host, "www.tiktok.com")
        XCTAssertEqual(url!.path, "/v2/auth/authorize")
        let comps = URLComponents(url: url!, resolvingAgainstBaseURL: false)!
        let dict: [String: String] = comps.queryItems!.reduce( into: [String:String](), { $0[$1.name] = $1.value })
        XCTAssertEqual(dict["state"], "test-state")
        // bundle id is org.cocoapods.AppHost-TikTokOpenAuthSDK-Unit-Tests
        XCTAssertEqual(dict["app_identity"], "2e753650bcb5e242a96020e569d27fdb2c7fde7cdc5d8e816e71a887bd4afa7e51065337f438b2b2059bfbbb3859889b6d6e594657622adbb715cfba9f9f40ec")
        XCTAssertEqual(dict["request_id"], "test-request-id")
        XCTAssertEqual(dict["sdk_version"], TikTokInfo.currentVersion)
        XCTAssertEqual(dict["device_platform"], "iphone")
        XCTAssertEqual(dict["client_key"], "aaaa")
        let perm = dict["scope"]
        let permCheck = perm == "p1,p2" || perm == "p2,p1"
        XCTAssertTrue(permCheck)
    }
    
    func testBuildOpenURL_native_success() {
        let authReq = TikTokAuthRequest(scopes: ["p1","p2"], redirectURI: "https://www.test.com/test")
        authReq.service = TikTokAuthService(urlOpener: MockURLOpener())
        authReq.requestID = "test-request-id"
        authReq.state = "test-state"
        let url = authReq.service.buildOpenURL(from: authReq)
        XCTAssertNotNil(url)
        XCTAssertEqual(url!.scheme, "https")
        XCTAssertEqual(url!.host, "www.tiktok.com")
        XCTAssertEqual(url!.path, "/opensdk/oauth")
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
    
    func testHandleRequest_native_success() {
        let redirectURI = "https://www.test.com/test"
        let req = TikTokAuthRequest(scopes: ["p1","p2"], redirectURI: redirectURI)
        req.requestID = "test-request-id"
        req.state = "test-state"
        let serv = TikTokAuthService(urlOpener: MockURLOpener())
        req.service = serv
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
    
    func testHandleRequest_webAuth_success() {
        let redirectURI = "https://www.test.com/test"
        let req = TikTokAuthRequest(scopes: ["p1","p2"], redirectURI: redirectURI)
        req.requestID = "test-request-id"
        req.state = "test-state"
        req.isWebAuth = true
        let serv = TikTokAuthService(urlOpener: MockURLOpener(tiktokInstalled: false))
        req.service = serv
        let tiktokExpectation = XCTestExpectation(description: "Expect to open SafariViewController")
        
        let ret = serv.handleRequest(req, completion: { _ in
            tiktokExpectation.fulfill()
        })
        XCTAssertEqual(serv.redirectURI, redirectURI)
        XCTAssertNotNil(serv.completion)
        let url = URL(string: "aaaa://response.bridge.tiktok.com/oauth?from_platform=tiktokopensdk&code=test-auth-code&request_id=test-request-id&error_code=0&response_id=test-response-id&state=test-state")!
        do {
            try serv.completion!(TikTokAuthResponse(fromURL: url, redirectURI: redirectURI, fromWeb: true))
        } catch {
            XCTFail("Should not throw error")
        }
        wait(for: [tiktokExpectation], timeout: 1)
        XCTAssertTrue(ret)
    }
    
    func testHandleResponse_native_invalidRedirectURI() {
        let redirectURI = "https://www.test.com/test"
        let req = TikTokAuthRequest(scopes: ["p1","p2"], redirectURI: redirectURI)
        req.requestID = "test-request-id"
        req.state = "test-state"
        let serv = TikTokAuthService(urlOpener: MockURLOpener())
        req.service = serv
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
        let serv = TikTokAuthService(urlOpener: MockURLOpener())
        XCTAssertFalse(serv.handleResponseURL(url: url))
    }
}
