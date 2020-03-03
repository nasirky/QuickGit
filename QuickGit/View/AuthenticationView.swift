//
//  AuthenticationView.swift
//  QuickGit
//
//  Created by Paul Kraft on 03.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import SwiftUI
import WebKit

struct AuthenticationView: UIViewRepresentable {

    // MARK: Nested types

    final class Coordinator: NSObject {

        let view: AuthenticationView

        init(view: AuthenticationView) {
            self.view = view
        }

    }

    // MARK: Stored properties

    let initialRequest: URLRequest
    let completion: (String) -> Void

    // MARK: Methods

    func makeUIView(
        context: UIViewRepresentableContext<AuthenticationView>
    ) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        // TODO: Change configuration?
        let view = WKWebView(frame: .zero, configuration: configuration)
        return view
    }

    func updateUIView(
        _ webView: WKWebView,
        context: UIViewRepresentableContext<AuthenticationView>
    ) {
        webView.navigationDelegate = context.coordinator
        let request = initialRequest

        let types = WKWebsiteDataStore.allWebsiteDataTypes()
        WKWebsiteDataStore.default()
            .removeData(ofTypes: types,
                        modifiedSince: .distantPast) {
                HTTPCookieStorage.shared.removeCookies(since: .distantPast)
                URLCache.shared.removeAllCachedResponses()
                webView.load(request)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(view: self)
    }

}

// MARK: - WKNavigationDelegate

extension AuthenticationView.Coordinator: WKNavigationDelegate {

    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print(#function, webView)
    }

    func webView(_ webView: WKWebView,
                 didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print(#function, webView, String(describing: navigation))
    }

    func webView(_ webView: WKWebView,
                 didCommit navigation: WKNavigation!) {
        print(#function, String(describing: navigation))
    }

    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation!) {
        print(#function, String(describing: navigation))
    }

    func webView(_ webView: WKWebView,
                 didStartProvisionalNavigation navigation: WKNavigation!) {
        print(#function, String(describing: navigation))
    }

    func webView(_ webView: WKWebView,
                 didFail navigation: WKNavigation!,
                 withError error: Error) {
        print(#function, String(describing: navigation), error)
    }

    func webView(_ webView: WKWebView,
                 didFailProvisionalNavigation navigation: WKNavigation!,
                 withError error: Error) {
        print(#function, String(describing: navigation), error)
    }

    func webView(_ webView: WKWebView,
                 didReceive challenge: URLAuthenticationChallenge,
                 completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print(#function, challenge)
        completionHandler(.useCredential, nil)
    }

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(#function, navigationAction)
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print(#function, navigationResponse)
        decisionHandler(.allow)

        if let url = navigationResponse.response.url,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let code = components.queryItems?.first(where: { $0.name == "code" })?.value {
                view.completion(code)
        }
    }

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 preferences: WKWebpagePreferences,
                 decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        print(#function, navigationAction, preferences)
        decisionHandler(.allow, .init())
    }

}
