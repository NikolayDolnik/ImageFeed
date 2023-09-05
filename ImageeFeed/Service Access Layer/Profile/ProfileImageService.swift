//
//  ProfileImageService.swift
//  ImageeFeed
//
//  Created by Dolnik Nikolay on 24.08.2023.
//

import Foundation

final class ProfileImageService {
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    private (set) var avatarURL: String?
    private var token = OAuth2TokenStorage().token
    private let urlSession = URLSession.shared
    //private let url = URL(string: "https://api.unsplash.com/users/:")!
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>)->Void ) {
        let url = URL(string: "https://api.unsplash.com/users/\(username)")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = urlSession.objectTask(for: request, completion: { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return print("ошибка загрузки аватара пользователя") } // TODO: - обработать ошибку
            switch result {
            case .success(let user):
                guard let avatarURL = user.imageSize(size: .small) else {return}
                self.avatarURL = avatarURL
                completion(.success(avatarURL))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.DidChangeNotification,
                        object: self,
                        userInfo: ["URL": avatarURL ]) //поменял UserResult.imageSize(size: .small) на аватар
            case .failure(let error):
                completion(.failure(error))
            }})
        
        
        /* Старая функция
        let task = urlSession.dataTask(with: request) { [weak self] data, response,error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data,
                  let user = try? JSONDecoder().decode(UserResult.self, from: data) else {
                print("ошибка user")
                return
            }
            self.avatarURL = user.profileImage?["small"]
            completion(.success(user.profileImage?["small"] ?? ""))
            NotificationCenter.default
                .post(
                    name: ProfileImageService.DidChangeNotification,
                    object: self,
                    userInfo: ["URL": user.profileImage!["small"]]) //кка верно записать
        }
         */
        
        task.resume()
    }
}
