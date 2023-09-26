//
//  Photo.swift
//  ImageeFeed
//
//  Created by Dolnik Nikolay on 05.09.2023.
//

import Foundation

public struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURl: String
    let largeImgaeURL:String
    var isLiked: Bool
    
    static func getPhoto(photo: PhotoResult )-> Photo {
        let photo = Photo( id: photo.id,
                           size: CGSize(width: photo.sizeWight, height: photo.sizeHeight),
                           createdAt: dateFormatterISO8601.date(from: (photo.createdAt ?? "")) ,
                           welcomeDescription: photo.welcomeDescription ?? "",
                           thumbImageURl: photo.urlsPhoto.thumb,
                           largeImgaeURL: photo.urlsPhoto.full,
                           isLiked: photo.isLiked)
        return photo
    }
}

struct PhotoResult: Codable {
    let id: String
    let sizeWight: Double
    let sizeHeight: Double
    let createdAt: String?
    let updatedAt: String?
    let color: String
    let blurHash: String
    let likes: Int
    let welcomeDescription: String?
    let isLiked: Bool
    let urlsPhoto: UrlsResult

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case sizeWight = "width"
        case sizeHeight = "height"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case color = "color"
        case blurHash = "blur_hash"
        case likes = "likes"
        case welcomeDescription = "description"
        case urlsPhoto = "urls"
        case isLiked = "liked_by_user"
    }
}

struct UrlsResult: Codable {
    let full: String
    let small: String
    let thumb: String
    
    enum CodingKeys: String, CodingKey {
        case  full = "full"
        case small = "small"
        case thumb = "thumb"
    }
    
}

struct LikedPhotoResult: Decodable {
    let photo: LikeByUserResult
}
struct LikeByUserResult: Decodable {
    let likedByUser: Bool
    private enum CodingKeys: String, CodingKey {
        case likedByUser = "liked_by_user"
    }
}

