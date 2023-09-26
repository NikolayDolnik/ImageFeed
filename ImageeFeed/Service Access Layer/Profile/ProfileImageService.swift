//
//  ProfileImageService.swift
//  ImageeFeed
//
//  Created by Dolnik Nikolay on 24.08.2023.
//

import Foundation

public protocol ProfileImageServiceProtocol {
    var avatarURL: String? {get}
}

final class ProfileImageService: ProfileImageServiceProtocol {
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    private (set) var avatarURL: String?
    private var token = OAuth2TokenStorage().token
    private let urlSession = URLSession.shared

    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>)->Void ) {
        let url = URL(string: "https://api.unsplash.com/users/\(username)")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = urlSession.objectTask(for: request, completion: { [weak self] (result: Result<UserResult, Error>) in
            switch result {
            case .success(let user):
                guard let avatarURL = user.imageSize(size: .small) else {
                    return completion(.failure(NetworkError.loadError("Ошибка ProfileImage")))
                }
                self?.avatarURL = avatarURL
                completion(.success(avatarURL))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.DidChangeNotification,
                        object: self,
                        userInfo: ["URL": avatarURL ])
            case .failure(let error):
                completion(.failure(error))
            }})
        task.resume()
    }
}
