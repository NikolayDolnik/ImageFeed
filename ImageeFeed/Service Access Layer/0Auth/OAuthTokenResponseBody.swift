//
//  OAuthTokenResponseBody.swift
//  ImageeFeed
//
//  Created by Dolnik Nikolay on 06.06.2023.
//

import Foundation

struct OAuthTokenResponseBody : Decodable {
    let accesToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    
    private enum CodingKeys: String, CodingKey {
    case accesToken = "access_token"
    case tokenType =  "token_type"
    case scope = "scope"
    case createdAt = "created_at"
    }
    
}
