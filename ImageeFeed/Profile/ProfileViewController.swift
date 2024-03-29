//
//  ProfileViewController.swift
//  ImageeFeed
//
//  Created by Dolnik Nikolay on 18.05.2023.
//
import UIKit
import Kingfisher
import WebKit

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? {get set}
    func updateAvatar(from url:URL)
    func loadProfile(_ profile: Profile?)
    func updateAvatarError()
    func configure(_ presenter: ProfileViewPresenterProtocol)
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
   
    // MARK: - Properties

    private var profileImageServiceObserver: NSObjectProtocol?
    var presenter: ProfileViewPresenterProtocol?
    
    private lazy var profileIcon: UIImageView = {
        let profileImage = UIImage(named: "Profile")
        let profileIcon = UIImageView()
        profileIcon.translatesAutoresizingMaskIntoConstraints = false
        profileIcon.image = profileImage
        return profileIcon
    }()
    
   lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var loginLabel: UILabel = {
        let loginLabel = UILabel()
        loginLabel.text = "@ekaterina_nov"
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        loginLabel.textColor = .gray
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        return loginLabel
    }()
    
    lazy var descriptionLabel: UILabel = {
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
        logOutButton.accessibilityIdentifier = "logout_button"
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        return logOutButton
    }()
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileView()
        presenter?.logIn()
        loadProfile(presenter?.profile())
    }
    
    // MARK: - Methods
    
    func configure(_ presenter: ProfileViewPresenterProtocol){
        self.presenter = presenter
        presenter.view = self
    }
    
    func updateAvatar(from url:URL){
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        profileIcon.kf.setImage(with: url, options: [.processor(processor)])
    }
    
    func updateAvatarError(){
        showAlert(title: "Ошибка", message: "Не удалось загрузить аватар", actions: nil)
    }
    
    func loadProfile(_ profile: Profile?) {
        self.nameLabel.text = profile?.name ?? ""
        self.loginLabel.text = profile?.logineName ?? ""
        self.descriptionLabel.text = profile?.bio ?? ""
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
        self.presenter?.updateAvatar()
    }
    
    @objc
    private func didTapLogOutButton() {
        var actions: [UIAlertAction] =  [UIAlertAction(title: "Да", style: .default, handler: {_ in self.presenter?.logOut()})]
        actions.append(UIAlertAction(title: "Нет", style: .default, handler: nil))
        showAlert(title: "«Пока, пока!»", message: "«Уверенны, что хотите выйти?»", actions: actions)
    }
}


