//
//  ImageListServie.swift
//  ImageeFeed
//
//  Created by Dolnik Nikolay on 05.09.2023.
//

import UIKit

final class ImageListService {
    private var lastLoadedPage: Int?
    private (set) var photos: [Photo] = []
    private let urlSession = URLSession.shared
    private let token = OAuth2TokenStorage().token
    private var taskFree: Bool = true
   // private var page : Int = 0
    static let shared = ImageListService()
    static let DidChangeNotification = Notification.Name(rawValue: "ImageListServiceDidChange")
    
    func fetchPhotosNextpage(){
        // оределить номер с которой загружаем страницу, не как параметр функции
        //если идет закачка, то новый запрос не создается
        assert(Thread.isMainThread)
        guard taskFree else { return }
        var page = lastLoadedPage == nil ? 0 : lastLoadedPage!
        page+=1
        
        //Делаем загрузку нужной странички - получаем массив из 10 карточек
        photoPageReguest(page: page, completion: { [weak self] result in
            guard let self = self else { return }
            switch result{
            case .success(let photos):
                self.photos = photos
                self.taskFree = true
                NotificationCenter.default
                    .post(
                        name: ImageListService.DidChangeNotification,
                        object: self,
                        userInfo: ["URL": self.photos])
            case .failure():
                print("Ошибка")
            }
        })
    }
    
    
    
}

extension ImageListService {
    
    private func photoPageReguest(page: Int, completion: @escaping (Result<[Photo], Error>)->Void ) {
        let url = URL(string: "https://api.unsplash.com/photos")!
        let perPage = 10 //количество картинок на странице
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
                print(photoResult)
                completion(.success(photos))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        self.taskFree = false
        self.lastLoadedPage = page
        task.resume()
    }
    
    private func photoPageRequest(page: Int) -> URLRequest {
        let url = URL(string: "https://api.unsplash.com/photos")!
        let perPage = 10 //количество картинок на странице
        return URLRequest.makeHTTPRequest(
            path: "?page=\(page)"
            + "&&per_page=\(perPage)"
            + "&&order_by=popular",
            httpMethod: "GET",
            baseURL: url
        )
    }
    
}


