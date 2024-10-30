//
//  SwiftUIView.swift
//  SwiftUI-WebView
//
//  Created by Vamsi Kallepalli on 10/15/24.
//

import SwiftUI
import WebKit

// Step 1: Create a Coordinator class to handle messages from JavaScript
class WebViewCoordinator: NSObject, WKScriptMessageHandler {
    var parent: WebView

    init(parent: WebView) {
        self.parent = parent
    }
    
    // This function will be called when JavaScript sends a message
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "callbackHandler" {
            if let messageBody = message.body as? String {
                print("JavaScript message received: \(messageBody)")
                parent.onJavaScriptMessage(messageBody)
            }
        }
    }
}

struct WebView: UIViewRepresentable {
    let htmlContent: String
    var onJavaScriptMessage: (String) -> Void

    func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator(parent: self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()

        // Step 2: Add a user content controller for handling JavaScript messages
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "callbackHandler")
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        let webViewWithConfig = WKWebView(frame: .zero, configuration: config)
        return webViewWithConfig
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.loadHTMLString(htmlContent, baseURL: nil)
    }
}

