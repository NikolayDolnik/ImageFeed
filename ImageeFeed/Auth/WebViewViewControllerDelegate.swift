//
//  WebViewViewControllerDelegate.swift
//  ImageeFeed
//
//  Created by Dolnik Nikolay on 01.06.2023.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
    
}

