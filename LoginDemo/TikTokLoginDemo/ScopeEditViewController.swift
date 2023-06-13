/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit
import TikTokOpenAuthSDK
import TikTokOpenSDKCore

@objc
class ScopeEditViewController: UIViewController {
    let scopeListViewController: ScopeListViewController = ScopeListViewController()
    private var authRequest: TikTokAuthRequest?

    func setupUI() {
        view.translatesAutoresizingMaskIntoConstraints = false
        let scopeListVC = scopeListViewController
        add(childViewController: scopeListVC)
        let bottomBarVC = BottomBarViewController()
        add(childViewController: bottomBarVC)

        NSLayoutConstraint.activate([
            scopeListVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            scopeListVC.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            scopeListVC.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            scopeListVC.view.bottomAnchor.constraint(equalTo: bottomBarVC.view.topAnchor)
        ])

        NSLayoutConstraint.activate([
            bottomBarVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBarVC.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            bottomBarVC.view.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        bottomBarVC.authBtn.addTarget(self, action: #selector(sendRequest), for: .touchUpInside)
    }

    @objc
    func sendRequest() {
        guard let viewModel = scopeListViewController.viewModel else {
            return
        }
        let authRequest = viewModel.toAuthRequest()
        self.authRequest = authRequest
        authRequest.send { [weak self] response in
            guard let self = self, let authRequest = response as? TikTokAuthResponse else { return }
            self.handleAuthResponse(authRequest)
        }
    }

    func handleAuthResponse(_ res: TikTokAuthResponse) {
        if res.errorCode != .noError {
            let message = "Error: \(res.error ?? "") \n Error Description: \(res.errorDescription ?? "")"
            presentPopup(title: "Authorization Failed!", message: message, accessToken: "")
        }
        fetchAccessToken(res)
        self.authRequest = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    /// [!!]Attn: This is for demo purpose. Do NOT request access token from the client.
    /// We recommend exchanging auth code for access token from your backend.
    func fetchAccessToken(_ res: TikTokAuthResponse) {
        guard let code = res.authCode,
              let grantedPermissions = res.grantedPermissions,
              let authRequest = self.authRequest else { return }
        
        let urlParams = ["code" : code,
                         "client_key" : TikTokInfo.clientKey,
                         "grant_type": "authorization_code",
                         "code_verifier": authRequest.pkce.codeVerifier,
                         "redirect_uri": authRequest.redirectURI ?? "",
                         // Use your app's client_secret from dev portal that matches the client_key of your app
                         "client_secret": "28cd717c25d74a38c00dc87301523448"]
        let httpBody = urlParams.map { "\($0.key)=\($0.value)" }
                                .joined(separator: "&")
                                .data(using: .utf8)
        guard let url = URL(string: "https://open-platform.tiktokapis.com/v2/oauth/token/") else {
            return
        }
        var request = URLRequest(url: url)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        request.httpMethod = "POST"
        request.httpBody = httpBody
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if error != nil {
                self.presentPopup(title: "Failed to get access token", message: "Network request for access token failed", accessToken: "")
                return
            }
            guard let data = data else {
                return
            }
            do {
                if let dataDic = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let accessToken = dataDic["access_token"] as? String, let openID = dataDic["open_id"] as? String {
                        self.fetchUserInfo(accessToken: accessToken, openID: openID, grantedPermissions: Array(grantedPermissions))
                    } else if let errorDescription = dataDic["error_description"], let error = dataDic["error"] {
                        self.presentPopup(title: "Failed to get access token", message:"Error:\(error) \n Error Description:\(errorDescription)", accessToken: "")
                    } else {
                        self.presentPopup(title: "Failed to parse data", message: "Failed to parse data for access token", accessToken: "")
                    }
                }
            } catch {
                self.presentPopup(title: "Failed to parse data", message: "Failed to parse data for access token", accessToken: "")
            }
        }
        task.resume()
    }
    
    /// This shows how to use access token to request open APIs
    func fetchUserInfo(accessToken: String, openID: String, grantedPermissions: [String]) {
        let domain = "https://open-api.tiktok.com/oauth/userinfo/"
        guard var urlComp = URLComponents(string: domain) else {
            return
        }
        urlComp.queryItems = [
            URLQueryItem(name: "access_token", value: accessToken),
            URLQueryItem(name: "open_id", value: openID)
        ]
        guard let url = urlComp.url else {
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if error != nil {
                self.presentPopup(title: "Failed to get user info", message: "Network request for user info failed", accessToken: "")
                return
            }

            guard let data = data else {
                return
            }

            do {
                let deserializedObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let dataDict = deserializedObject?["data"] as? [String: Any] {
                    if let displayName = dataDict["display_name"] as? String {
                        let title = "Getting user info succeeded"
                        let message = "Access token: \(accessToken) \n Display name: \(displayName)\n Granted Permissions: \(grantedPermissions)"
                        self.presentPopup(title: title, message: message, accessToken: accessToken)
                    }
                }
            } catch {
                self.presentPopup(title: "Failed to parse data", message: "Failed to parse data for user info", accessToken: "")
            }
        }
        task.resume()
    }

    func presentPopup(title: String, message: String, accessToken: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default))
        if !accessToken.isEmpty {
            alert.addAction(UIAlertAction(title: "Copy Access Token", style: .default) { _ in
                let pasteBoard = UIPasteboard.general
                pasteBoard.string = accessToken
            })
        }
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }

}
