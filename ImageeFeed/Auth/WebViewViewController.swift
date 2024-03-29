//
//  WebViewViewController.swift
//  ImageeFeed
//
//  Created by Dolnik Nikolay on 01.06.2023.
//

import Foundation
import UIKit
import WebKit

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? {get set}
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

final class WebViewViewController: UIViewController {
    
    
    // MARK: - IBOutlet & IBOaction
    
    @IBOutlet private var progressView: UIProgressView!
    @IBOutlet private var webView: WKWebView!
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    var presenter: WebViewPresenterProtocol?
    private var estimatedProgressObservation: NSKeyValueObservation?
    weak var delegate: WebViewViewControllerDelegate?
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.accessibilityIdentifier = "WebViewController"
        presenter?.viewDidLoad()
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self, let presenter = self.presenter else {return}
                 presenter.didUpdateProgressValue(self.webView.estimatedProgress)
                 //self.updateProgress()
             })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //TODO: - удалить функцию ниже
    
    private func updateProgress() {
        presenter?.didUpdateProgressValue(webView.estimatedProgress)
        //        progressView.progress = Float(webView.estimatedProgress)
        //        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    
}


// MARK: - WebViewViewControllerProtocol
extension WebViewViewController: WebViewViewControllerProtocol {
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    func setProgressValue(_ newValue: Float){
        progressView.progress = newValue
    }
    func setProgressHidden(_ isHidden: Bool){
        progressView.isHidden = isHidden
    }
    
}


// MARK: - WKNavigationDelegate

extension WebViewViewController: WKNavigationDelegate {
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
