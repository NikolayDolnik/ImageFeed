//
//  ProfileService.swift
//  ImageeFeed
//
//  Created by Dolnik Nikolay on 22.08.2023.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private(set) var profile: Profile?
    private let urlSession = URLSession.shared
    private let url = URL(string: "https://api.unsplash.com/me")!
    private var token = OAuth2TokenStorage().token
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>)->Void ) {
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = urlSession.objectTask(for: request, completion: { [weak self] (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let profileinfo):
                self?.profile = Profile.getProfile(profileinfo)
                guard let profile = self?.profile else {
                    return completion(.failure(NetworkError.loadError("Ошибка fetchProfile")))
                }
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }})
        task.resume()
    }
    
}
