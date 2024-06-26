//
//  OAuth2TokenStorage.swift
//  ImageeFeed
//
//  Created by Dolnik Nikolay on 06.06.2023.
//

import Foundation
import SwiftKeychainWrapper

class OAuth2TokenStorage {
    
    //private var userDefaults: UserDefaults
    private enum Keys: String {
        case token
    }
   /*
    init(userDefaults: UserDefaults = .standard ) {
        self.userDefaults = userDefaults
    }
    */
    
    var token : String {
        get {
            guard let token: String = KeychainWrapper.standard.string(forKey: Keys.token.rawValue) else {
             return ""
         }
            /*
             Старый способ через Юзер дефалтс
            guard let data = userDefaults.data(forKey: Keys.token.rawValue),
                  let token = try? JSONDecoder().decode( String.self, from: data) else {
                return ""
            }
             */
            return token 
        }
        set {
            let isSuccess = KeychainWrapper.standard.set(newValue, forKey: Keys.token.rawValue)
             guard isSuccess else {
                 // ошибка
             return print("Невозможно сохранить результат")
             }
            /*
            guard let data = try? JSONEncoder().encode(newValue) else {
               return print("Невозможно сохранить результат")
            }
            userDefaults.set(data, forKey: Keys.token.rawValue)
            */
        }
    }
    
    
}
