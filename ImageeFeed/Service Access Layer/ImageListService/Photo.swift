//
//  Photo.swift
//  ImageeFeed
//
//  Created by Dolnik Nikolay on 05.09.2023.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURl: String
    let largeImgaeURL:String
    let isLiked: Bool
  
    
    static func getPhoto(photo: PhotoResult )-> Photo {
       let photo = Photo( id: photo.id,
                           size: CGSize(width: photo.sizeWight, height: photo.sizeHeight),
                           createdAt: DateFormatter().date(from: photo.createdAt ?? "") ,
                           welcomeDescription: photo.welcomeDescription ?? "",
                           thumbImageURl: photo.urlsPhoto[Size.thumb.rawValue] ?? "",
                           largeImgaeURL: photo.urlsPhoto[Size.large.rawValue] ?? "",
                           isLiked: photo.isLiked)
        return photo
    }
    
    enum Size: String {
        case thumb = "thumb"
        case large = "large"
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
    let urlsPhoto: [String:String]

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


