//
//  AuthViewController.swift
//  SpotifyClone
//
//  Created by Krystian Szczepankiewicz on 6/25/24.
//

import UIKit
import WebKit

class AuthViewController: UIViewController, WKNavigationDelegate {

    // WebView for displaying authentication flow
    private let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()

    // Completion handler to be called after authentication
    public var completionHandler: ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self  // Setting navigation delegate
        view.addSubview(webView)  // Adding webView to view hierarchy

        // Load the sign-in URL if available
        guard let url = AuthManager.shared.signInURL else {
            return
        }
        webView.load(URLRequest(url: url))  // Load the URL request in webView
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds  // Adjusting webView frame to fit view bounds
    }

    // MARK: - WKNavigationDelegate

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }

        // Extract the authorization code from the URL query parameters
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code" })?.value else {
            return
        }

        webView.isHidden = true  // Hide webView while processing

        // Exchange the received code for an access token
        AuthManager.shared.exchangeCodeForToken(code: code) { [weak self] success in
            DispatchQueue.main.async {
                // Pop back to the root view controller
                self?.navigationController?.popToRootViewController(animated: true)
                // Call completion handler with success status
                self?.completionHandler?(success)
            }
        }
    }
}
