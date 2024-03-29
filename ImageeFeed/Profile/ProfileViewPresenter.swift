//
//  ProfileViewPresenter.swift
//  ImageeFeed
//
//  Created by Dolnik Nikolay on 19.09.2023.
//

import Foundation
import WebKit

public protocol ProfileViewPresenterProtocol: AnyObject{
    var view: ProfileViewControllerProtocol? {get set}
    var profileService: ProfileServiceProtocol {get}
    var profileImageService: ProfileImageServiceProtocol {get}
    func logIn()
    func logOut()
    func updateAvatar()
    func profile()-> Profile?
}


final class ProfileViewPresenter: ProfileViewPresenterProtocol {
   
    weak var view: ProfileViewControllerProtocol?
//    private let profileService = ProfileService.shared
//    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    var profileService: ProfileServiceProtocol
    var profileImageService: ProfileImageServiceProtocol
    
    init( profileService: ProfileServiceProtocol = ProfileService.shared,
          profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared
    ){
        self.profileService = profileService
        self.profileImageService = profileImageService
    }
    
    func logIn() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.DidChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self else {return}
                self.updateAvatar()
            }
    }
    
    func logOut() {
        OAuth2TokenStorage().token = ""
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()){ records in
            records.forEach{ record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first else {
            fatalError("Invalid Configuration")
        }
        let vc = SplashViewController()
        window.rootViewController = vc
    }
    
    func updateAvatar(){
        guard let profileImageURL = profileImageService.avatarURL,
              let url = URL(string: profileImageURL)
        else {
            view?.updateAvatarError()
            return
        }
        view?.updateAvatar(from: url)
    }
    
    func profile()-> Profile? {
        guard let profile = profileService.profile else { return nil }
        return profile
    }
    
}
