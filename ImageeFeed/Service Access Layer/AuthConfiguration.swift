//
//  Constants.swift
//  ImageeFeed
//
//  Created by Dolnik Nikolay on 31.05.2023.
//

import Foundation

let AccessKey = "KsCsSFNPMeGm1y3oXjja6ibmMG7sJCYym_G-j0mvW34"
let SecretKey = "V7kWUK-D3FqWeaRqFI0o6IxuVXzQR2i5jqTGY4QMaWs"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public + read_user + write_likes"
let DefaultBaseUrl = URL(string: "https://unsplash.com")!
let defaultApiURL = URL(string: "https://api.unsplash.com")!
let snakeDecoder = SnakeCaseJSONDecoder()
let dateFormatterISO8601 = ISO8601DateFormatter()
var UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"


struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseUrl: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseUrl: URL, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseUrl = defaultBaseUrl
        self.authURLString = authURLString
    }
    
    static var standart:AuthConfiguration{
        return AuthConfiguration(accessKey: AccessKey, secretKey: SecretKey, redirectURI: RedirectURI, accessScope: AccessScope, defaultBaseUrl: DefaultBaseUrl, authURLString: UnsplashAuthorizeURLString)
    }
}
