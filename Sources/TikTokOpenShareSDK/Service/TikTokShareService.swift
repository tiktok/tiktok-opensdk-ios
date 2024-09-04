/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit
import TikTokOpenSDKCore
import SafariServices

fileprivate let USER_CANCELED_SHARE = "User canceled share"
fileprivate let TIKTOK_NOT_INSTALLED = "TikTok is not installed"

@objc (TTKSDKShareService)
class TikTokShareService: NSObject, TikTokRequestResponseHandling, SFSafariViewControllerDelegate {
    private(set) var completion: ((TikTokBaseResponse) -> Void)?
    private(set) var request: TikTokShareRequest?
    private let urlOpener: TikTokURLOpener
    private var safariVC: SFSafariViewController?

    init(urlOpener: TikTokURLOpener = UIApplication.shared) {
        self.urlOpener = urlOpener
    }

    //MARK: - TikTokRequestHandling
    func handleRequest(_ request: TikTokBaseRequest, completion: ((TikTokBaseResponse) -> Void)?) -> Bool {
        guard let shareRequest = request as? TikTokShareRequest else { return false }
        self.completion = completion
        self.request = shareRequest
        if urlOpener.isTikTokInstalled() {
            guard let url = buildOpenURL(from: request) else { return false }
            (urlOpener as? UIApplication)?.open(url, options: [:]) { success in
                if !success, let cancelURL = self.constructErrorURL(errorCode: String(TikTokShareResponseErrorCode.cancelled.rawValue),
                                                               shareState: String(TikTokShareResponseState.cancelled.rawValue),
                                                               errorDescription: USER_CANCELED_SHARE) {
                    self.handleResponseURL(url: cancelURL)
                }
            }
            return true
        } else {
            handleTikTokNotInstalled()
            return false
        }
    }
    
    func buildOpenURL(from req: TikTokBaseRequest) -> URL? {
        guard let shareReq = req as? TikTokShareRequest else { return nil }
        guard let baseURL = URL(string:"\(TikTokInfo.universalLink)\(TikTokInfo.universalLinkSharePath)") else { return nil }
        guard var urlComps = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else { return nil }
        urlComps.queryItems = shareReq.convertToQueryParams()
        return urlComps.url
    }
    
    // MARK: - TikTokResponseHandling
    @discardableResult
    func handleResponseURL(url: URL) -> Bool {
        guard let res = try? TikTokShareResponse(fromURL: url, redirectURI: request?.redirectURI ?? "") else { return false }
        return handleResponse(res)
    }
    
    @discardableResult
    func handleResponse(_ response: TikTokShareResponse) -> Bool {
        guard let closure = completion else { return false }
        closure(response)
        return true
    }

    // MARK: - Private
    private func buildOpenURLQueryParams(from request: TikTokBaseRequest) -> [URLQueryItem]? {
        guard let req = request as? TikTokShareRequest else {
            return nil
        }

        var queryParams = req.convertToQueryParams()
        if let urlScheme = req.customConfig?.callerUrlScheme {
            queryParams.append(URLQueryItem(name: "callback_url_scheme", value: urlScheme))
        }
        if let _ = req.state {
            queryParams.append(URLQueryItem(name: "state", value: req.state!))
        }
        return queryParams
    }
    
    //MARK: - Construct error URL
    private func constructErrorURL(errorCode: String, shareState: String, errorDescription: String) -> URL? {
        guard let request = request else { return nil }
        guard let url = URL(string: request.redirectURI ?? "") else { return nil }
        guard var urlComps = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        urlComps.queryItems = [
            URLQueryItem(name: "request_id", value: request.requestID),
            URLQueryItem(name: "error_code", value: errorCode),
            URLQueryItem(name: "share_state", value: shareState),
            URLQueryItem(name: "error_description", value: errorDescription),
            URLQueryItem(name: "from_platform", value: TikTokInfo.shareScheme)
        ]
        return urlComps.url
    }
    
    // MARK: - TikTok App Not Installed
    private func handleTikTokNotInstalled() {
        guard let hostViewController = request?.hostViewController ?? urlOpener.keyWindow?.rootViewController else {
            tikTokNotInstalledResponse()
            return
        }
        guard self.safariVC == nil else { return }
        guard let onelink = TikTokAppStoreModel.get().onelink(clientKey: TikTokInfo.clientKey) else { return }
        guard let oneLinkURL = URL(string: onelink) else { return }
        let safariVC = SFSafariViewController(url: oneLinkURL)
        safariVC.modalPresentationStyle = .popover
        safariVC.delegate = self
        if let popoverController = safariVC.popoverPresentationController, let hostView = hostViewController.view {
            popoverController.sourceView = hostView
            safariVC.preferredContentSize = CGSize(width: hostView.bounds.maxX, height: hostView.bounds.maxY)
            popoverController.sourceRect = CGRect(x: hostView.bounds.minX, y: hostView.bounds.minY, width: 0, height: 0)
        }
        self.safariVC = safariVC
        hostViewController.present(safariVC, animated: true)
    }
    
    func tikTokNotInstalledResponse() {
        if let tiktokNotInstalledURL = self.constructErrorURL(errorCode: String(TikTokShareResponseErrorCode.common.rawValue),
                                                               shareState: String(TikTokShareResponseState.tiktokIsNotInstalled.rawValue),
                                                               errorDescription: TIKTOK_NOT_INSTALLED) {
            self.handleResponseURL(url: tiktokNotInstalledURL)
        }
    }
    
    //MARK: SFSafariViewControllerDelegate
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        self.safariVC?.dismiss(animated: true, completion: { [weak self] in
            self?.safariVC = nil;
            self?.tikTokNotInstalledResponse()
        })
    }
}
