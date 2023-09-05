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
            guard let self else { return } // TODO: - обработать ошибку
            switch result {
            case .success(let profileinfo):
                self.profile = Profile.getProfile(profileinfo)
                guard let profile = self.profile else {return print("Ошибка fetchProfile")}
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }})
        
        /*
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error  in

                if let error = error {
                    completion(.failure(error))
                    return
                }
                if let response = response as? HTTPURLResponse,
                   response.statusCode < 200 || response.statusCode >= 300 {
                    // completion(.failure(NetworkError.codeError(response.statusCode)))
                    completion(.failure(response.statusCode as! Error))
                    return
                }
            //обьединить и визвать ошибку в комплишен
            guard let data = data,
                  let self,
                  let profileInfo = try? JSONDecoder().decode(ProfileResult.self, from: data)
            else { completion(.failure( NetworkError.urlSessionError )); return }
            
            self.profile = Profile.getProfile(profileInfo)
            //асинхронно пустить
            completion(.success(self.profile!))
        } */
        task.resume()
    }
    
}
