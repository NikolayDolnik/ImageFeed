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
    private var task: URLSessionTask?
    private var page : Int?
    static let DidChangeNotification = Notification.Name(rawValue: "ImageListServiceDidChange")
    
    func fetchPhotosNextpage(_ completion: @escaping (Result<[Photo], Error>)->Void ){
        // оределить номер с которой загружаем страницу, не как параметр функции
        //если идет закачка, то новый запрос не создается
        //assert(Thread.isMainThread)
        //if lastLoadedPage == page {return}
        //task?.cancel()
       // lastCode = code
        self.page = 1
        //let request = photoPageRequest(page: page!)
        var request = URLRequest(url: URL(string: "https://api.unsplash.com/photos?page=1")!)
        request.setValue("Bearer \(token))", forHTTPHeaderField: "Authorization")
        let task = urlSession.objectTask(for: request, completion: { [weak self] (result: Result< [PhotoResult], Error>) in
            guard let self = self else { return print("Ошибка загрузки страницы с фото") }
            switch result {
            case .success(let photoResult):
                for index in  photoResult{
                    let photo = Photo.getPhoto(photo: index)
                    self.photos.append(photo)
                }
                print(photoResult)
                completion(.success(self.photos))
                NotificationCenter.default
                    .post(
                        name: ImageListService.DidChangeNotification,
                        object: self,
                        userInfo: ["URL": self.photos ])
            case .failure(let error):
                completion(.failure(error))
            }
        })
        task.resume()
        // массив photos оюновляется из главного потока, добавляем фото в конец
        //после обновления массива photos публикуется нотификация
    }
    
    
    
}

extension ImageListService {
    
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


