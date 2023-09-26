//
//  OAuth2Service.swift
//  ImageeFeed
//
//  Created by Dolnik Nikolay on 06.06.2023.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    private var lastCode: String?
    private var task: URLSessionTask?
    
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue!
        }
    }
    
    
    func fetchAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == code {return}
        task?.cancel()
        lastCode = code
        
        guard let request = authTokenRequest(code: code) else {return}
        let task = urlSession.objectTask(for: request, completion: { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self else { return completion(.failure(NetworkError.loadError("Ошибка TokenRequest"))) }
            switch result {
            case .success(let body):
                let authToken = body.accesToken
                self.authToken = authToken
                completion(.success(authToken))
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
                self.lastCode = nil
            }})
        self.task = task
        task.resume()
    }
}

extension OAuth2Service {
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                Result { try decoder.decode(OAuthTokenResponseBody.self, from: data) }
            }
            completion(response)
        }
    }
    
    private func authTokenRequest(code: String) -> URLRequest? {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(AccessKey)"
            + "&&client_secret=\(SecretKey)"
            + "&&redirect_uri=\(RedirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: DefaultBaseUrl
        )
    }
}


