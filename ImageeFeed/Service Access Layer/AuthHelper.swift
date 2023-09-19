//
//  AuthHelper.swift
//  ImageeFeed
//
//  Created by Dolnik Nikolay on 16.09.2023.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest()-> URLRequest
    func code(from code: URL)-> String?
}

class AuthHelper: AuthHelperProtocol{
    
    let coonfiguration: AuthConfiguration
    
    init(coonfiguration: AuthConfiguration = .standart) {
        self.coonfiguration = coonfiguration
    }
    
    func authRequest() -> URLRequest {
        let url = authURL()
        return URLRequest(url:url)
    }
    func authURL()-> URL {
        var urlComponents = URLComponents(string: coonfiguration.authURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: coonfiguration.accessKey),
            URLQueryItem(name: "redirect_uri", value: coonfiguration.redirectURI),
           URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: coonfiguration.accessScope)
         ]
        return urlComponents.url!
    }
    
    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code" })
       {
           return codeItem.value
       } else {
           return nil
       }
    }
}
