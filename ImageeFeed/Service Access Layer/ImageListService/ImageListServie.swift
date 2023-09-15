//
//  ImageListServie.swift
//  ImageeFeed
//
//  Created by Dolnik Nikolay on 05.09.2023.
//

import UIKit

final class ImageListService {
    
    // MARK: - Properties
    
    private var lastLoadedPage: Int?
    private (set) var photos: [Photo] = []
    private let urlSession = URLSession.shared
    private let token = OAuth2TokenStorage().token
    private var taskFree: Bool = true
    static let shared = ImageListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImageListServiceDidChange")
    
    func fetchPhotosNextpage(){
        assert(Thread.isMainThread)
        guard taskFree else { return }
        var page = lastLoadedPage == nil ? 0 : lastLoadedPage!
        page+=1
        
        photoPageReguest(page: page, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let photos):
                self.photos += photos
                self.taskFree = true
                NotificationCenter.default
                    .post(
                        name: ImageListService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": self.photos])
            case .failure:
                print("Ошибка photoPageReguest")
            }
        })
    }
}


extension ImageListService {
    func likeChangeReguest(photo: Photo, completion: @escaping (Result<[Photo], Error>)->Void){
        var request = URLRequest.makeHTTPRequest(
            path: "/photos"
            + "/\(photo.id)"
            + "/like",
            httpMethod: (photo.isLiked ? "DELETE" : "POST"),
            baseURL: defaultApiURL
        )
        request.setValue("Bearer \(token))", forHTTPHeaderField: "Authorization")
        let task = urlSession.objectTask(for: request, completion: { [weak self] (result: Result<LikedPhotoResult, Error>) in
            guard let self = self else { return print("Ошибка загрузки страницы с фото") }
            switch result{
            case .success(let result):
                let like = result.photo.likedByUser
                if let index = self.photos.firstIndex(where: {$0.id == photo.id}) {
                    let photo = self.photos[index]
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURl: photo.thumbImageURl,
                        largeImgaeURL: photo.largeImgaeURL,
                        isLiked: like)
                    self.photos[index] = newPhoto
                }
                completion(.success(self.photos))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        task.resume()
    }

    private func photoPageReguest(page: Int, completion: @escaping (Result<[Photo], Error>)->Void ) {
        let url = URL(string: "https://api.unsplash.com/photos")!
        let perPage = 10
        var request = URLRequest.makeHTTPRequest(
            path: "?page=\(page)"
            + "&&per_page=\(perPage)"
            + "&&order_by=popular",
            httpMethod: "GET",
            baseURL: url
        )
        request.setValue("Bearer \(token))", forHTTPHeaderField: "Authorization")
        let task = urlSession.objectTask(for: request, completion: { [weak self] (result: Result< [PhotoResult], Error>) in
            guard let self = self else { return print("Ошибка загрузки страницы с фото") }
            switch result {
            case .success(let photoResult):
                var photos: [Photo]=[]
                for index in  photoResult{
                    let photo = Photo.getPhoto(photo: index)
                    photos.append(photo)
                }
                // print(photoResult)
                completion(.success(photos))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        self.taskFree = false
        self.lastLoadedPage = page
        task.resume()
    }
}



