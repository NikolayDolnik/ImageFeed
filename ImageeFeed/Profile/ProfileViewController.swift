//
//  ProfileViewController.swift
//  ImageeFeed
//
//  Created by Dolnik Nikolay on 18.05.2023.
//
import UIKit
import Kingfisher


final class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private let imageListService = ImageListService()
    
    private lazy var profileIcon: UIImageView = {
        let profileImage = UIImage(named: "Profile")
        let profileIcon = UIImageView()
        profileIcon.translatesAutoresizingMaskIntoConstraints = false
        profileIcon.image = profileImage
        return profileIcon
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var loginLabel: UILabel = {
        let loginLabel = UILabel()
        loginLabel.text = "@ekaterina_nov"
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        loginLabel.textColor = .gray
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        return loginLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, World!"
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.textColor = .white
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    private lazy var logOutButton: UIButton = {
        let buttonIcon = UIImage(named: "logout_button")?.withRenderingMode(.alwaysOriginal)
        let logOutButton = UIButton.systemButton(
            with: buttonIcon!,
            target: self,
            action: #selector(Self.didTapLogOutButton)
        )
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        return logOutButton
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.DidChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self else {return}
                self.updateAvatar()
            }
        profileView()
        loadProfile()
        updateAvatar()
        //imageListService.fetchPhotosNextpage{ result in print(result) }
    }
    
    // MARK: - Private function
    
    private func updateAvatar(){
        guard let profileImageURL = profileImageService.avatarURL,
              let url = URL(string: profileImageURL)
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        profileIcon.kf.setImage(with: url, options: [.processor(processor)])
    }
    
    private func loadProfile() {
        guard let profile = profileService.profile else {return print("ошибка обновления UI") }
        self.nameLabel.text = profile.name
        self.loginLabel.text = profile.logineName
        self.descriptionLabel.text = profile.bio
    }
    
    
    private func profileView() {
        
        view.addSubview(profileIcon)
        view.addSubview(nameLabel)
        view.addSubview(loginLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(logOutButton)
        view.backgroundColor = .ypBlack
        NSLayoutConstraint.activate([
            profileIcon.heightAnchor.constraint(equalToConstant: 70),
            profileIcon.widthAnchor.constraint(equalToConstant: 70),
            profileIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileIcon.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.heightAnchor.constraint(equalToConstant: 18),
            nameLabel.topAnchor.constraint(equalTo: profileIcon.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profileIcon.leadingAnchor),
            loginLabel.heightAnchor.constraint(equalToConstant: 18),
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 18),
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            logOutButton.heightAnchor.constraint(equalToConstant: 44),
            logOutButton.widthAnchor.constraint(equalToConstant: 44),
            logOutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45),
            logOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    @objc
    private func didTapLogOutButton() {
        // Очистить данные?
        self.nameLabel.text = "Необходимо авторизироваться"
        self.loginLabel.text = ""
        self.descriptionLabel.text = ""
        let profileBase = UIImage(named: "tab_profile_active")
        profileIcon.image = profileBase
        
    }
}

extension UIColor {
    static let ypBlack = UIColor(named: "YP Black")
}
