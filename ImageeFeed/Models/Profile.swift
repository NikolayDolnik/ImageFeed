//
//  ProfileResult.swift
//  ImageeFeed
//
//  Created by Dolnik Nikolay on 22.08.2023.
//

import Foundation

struct ProfileResult: Codable {
    
    let firstName: String
    let lastName: String?
    let userName: String
    let bio: String?
    
    private enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case userName = "username"
        case bio = "bio"
    }
}

struct Profile: Codable {
    var userName: String
    var name: String
    var logineName: String
    var bio: String
   
    static func getProfile(_ profileInfo: ProfileResult) -> Profile {
        let profile = Profile(
            userName: profileInfo.userName,
            name: profileInfo.firstName + " " + (profileInfo.lastName ?? ""),
            logineName: "@" + profileInfo.userName,
            bio: profileInfo.bio ?? "")
        return  profile
    }
    
}

struct UserResult: Codable {
    private var profileImage: [String:String]
    
    func imageSize(size: Size )-> String? {
        profileImage[size.rawValue]
    }
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
    
    enum Size: String {
        case small = "small"
        case medium = "medium"
        case large = "large"
    }
   
}


