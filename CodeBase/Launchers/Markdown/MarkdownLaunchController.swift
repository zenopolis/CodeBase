//
//  MarkdownLaunchController.swift
//  CodeBase
//
//  Created by David Kennedy on 13/05/2025.
//

import UIKit
import WebKit
import Ink

class MarkdownLaunchController: UIViewController {

    var markdownFileName: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: CGRect(), configuration: configuration)

        self.view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.readableContentGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.readableContentGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor)
        ].compactMap {$0})
        
        guard let url = Bundle.main.url(forResource: markdownFileName, withExtension: "md") else { return }
        guard let markdown = try? String(contentsOf: url, encoding: .utf8) else { return }
        
        let parser = MarkdownParser()
        let html = parser.html(from: markdown)
        
        webView.loadHTMLString(html, baseURL: nil)
    }
    
}
