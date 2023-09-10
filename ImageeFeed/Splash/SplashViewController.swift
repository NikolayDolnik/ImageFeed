//
//  SplashViewController.swift
//  ImageeFeed
//
//  Created by Dolnik Nikolay on 11.08.2023.
//

import Foundation
import UIKit
import ProgressHUD

class SplashViewController: UIViewController {
    private let oauth2Service = OAuth2Service()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let showGallerySegueIdentifier = "ShowGallery"
    private let showAuthSegueIdentifier = "ShowAuth"
    
    // MARK: - Верстка кодом
    private lazy var splashIcon: UIImageView = {
        let iconImage = UIImage(named: "splash_screen_logo")
        let splashIcon = UIImageView()
        splashIcon.translatesAutoresizingMaskIntoConstraints = false
        splashIcon.image = iconImage
        return splashIcon
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splashView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        authTest()
    }
}


// MARK: - Функции

extension SplashViewController: AuthViewControllerDelegate {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        self.fetchOAuthToken(code)
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showAlert()
            }
        }
    }
    
    private func fetchProfile(token: String){
        profileService.fetchProfile(token) { result in
            switch result {
            case .success(let profile):
                ProfileImageService.shared.fetchProfileImageURL(username: profile.userName) { result in print(result)}
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showAlert()
                break
            }
        }
    }
}

extension SplashViewController {
    
    func authTest() {
        if oauth2TokenStorage.token != "" {
            //switchToTabBarController()
            self.fetchProfile(token: oauth2TokenStorage.token)
        } else {
            let authViewController = UIStoryboard(name: "Main", bundle: .main)
                .instantiateViewController(identifier: "AuthViewController") as? AuthViewController
            authViewController?.delegate = self
            guard let authViewController = authViewController else { return }
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true)
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "«Что-то пошло не так(»", message: "«Не удалось войти в систему»", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func switchToTabBarController() {
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first else {
            fatalError("Invalid Configuration")
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(identifier: "tabBar")
        window.rootViewController = tabBarController
    }
    
    private func splashView() {
        view.addSubview(splashIcon)
        view.backgroundColor = .init(named: "YP Black")
        NSLayoutConstraint.activate([
            splashIcon.heightAnchor.constraint(equalToConstant: 75),
            splashIcon.widthAnchor.constraint(equalToConstant: 72),
            splashIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
}
