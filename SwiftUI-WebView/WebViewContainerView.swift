//
//  WebViewContainerView.swift
//  SwiftUI-WebView
//
//  Created by Vamsi Kallepalli on 10/22/24.
//

import SwiftUI
import WebKit

struct WebViewContainer: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        // Set up the web view and configuration
        let webView = WKWebView()
        
        // Load the URL
        let request = URLRequest(url: URL(string: "https://github.com/login") ?? url)
        webView.load(request)
        
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        // Update the view if needed, but nothing to update here as we're only loading a URL
    }
}
