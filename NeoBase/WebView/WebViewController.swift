//
//  WebViewController.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 08/09/2024.
//

import UIKit
import WebKit

public final class WebViewController: BaseViewController<WebViewModel> {
    private lazy var webView: WKWebView = {
        let webView = WKWebView().with(parent: view)
        webView.navigationDelegate = self
        
        return webView
    }()
    
    private lazy var headerView = WebViewHeaderView().with(parent: view)
    
    /// The observation object used to monitor the progress of the web view's loading process.
    private var webViewProgressObserver: NSKeyValueObservation?
    
    deinit {
        webViewProgressObserver = nil
    }
}

// MARK: - Life Cycle
public extension WebViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadWebView()
        observeWebViewProgress()
    }
}

// MARK: - Private Functionality
private extension WebViewController {
    func setupView() {
        headerView.constraint(\.leadingAnchor, equalTo: view.leadingAnchor)
        headerView.constraint(\.topAnchor, equalTo: view.safeAreaLayoutGuide.topAnchor)
        headerView.constraint(\.trailingAnchor, equalTo: view.trailingAnchor)
        
        webView.constraint(\.leadingAnchor, equalTo: view.leadingAnchor)
        webView.constraint(\.topAnchor, equalTo: headerView.bottomAnchor)
        webView.constraint(\.trailingAnchor, equalTo: view.trailingAnchor)
        webView.constraint(\.bottomAnchor, equalTo: view.bottomAnchor)
    }
    
    func loadWebView() {
        guard let url = viewModel.targetURL else {
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }

    /// Observes the web view's loading progress and updates the header view accordingly.
    func observeWebViewProgress() {
        webViewProgressObserver = webView.observe(\.estimatedProgress, options: .new) { [weak self] _, change in
            self?.headerView.setProgress(to: Float(change.newValue ?? 0))
        }
    }
}

// MARK: - WKNavigationDelegate Conformance
extension WebViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView.url?.absoluteString == Constant.xenditDemoCheckout {
            dismiss(animated: true) { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            }
            return
        }
        
        guard let title = webView.title else {
            return
        }
        
        headerView.setTitle(to: title)
    }
}
