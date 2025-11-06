//
//  WebViewWrapper.swift
//  GitHubUserList
//
//  Created by Nakajima on 2025/11/06.
//

import SwiftUI
import WebKit

public struct WebViewWrapper: UIViewRepresentable {
    public let url: URL

    public init(url: URL) {
        self.url = url
    }

    public func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    public func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
