//
//  OAuth2TokenStorage.swift
//  ImageeFeed
//
//  Created by Dolnik Nikolay on 06.06.2023.
//

import Foundation

class OAuth2TokenStorage {
    
    private var userDefaults: UserDefaults
    private enum Keys: String {
        case token
    }
    
    init(userDefaults: UserDefaults = .standard ) {
        self.userDefaults = userDefaults
    }
    
    var token : String {
        get {
            guard let data = userDefaults.data(forKey: Keys.token.rawValue),
                  let token = try? JSONDecoder().decode( String.self, from: data) else {
                return ""
            }
            return token
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
               return print("Невозможно сохранить результат")
            }
            userDefaults.set(data, forKey: Keys.token.rawValue)
        }
    }
    
    
}
