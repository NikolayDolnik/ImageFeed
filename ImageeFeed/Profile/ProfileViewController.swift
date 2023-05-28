//
//  ProfileViewController.swift
//  ImageeFeed
//
//  Created by Dolnik Nikolay on 18.05.2023.
//

import Foundation
import UIKit

final class ProfileViewController: UIViewController {
    
    private var profileIcon: UIImageView?
    private var nameLabel: UILabel?
    private var loginLabel: UILabel?
    private var descriptionLabel: UILabel?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        profileView()
    }
    
    func profileView() {
        
        let profileImage = UIImage(named: "Profile")
        let profileIcon = UIImageView()
        profileIcon.translatesAutoresizingMaskIntoConstraints = false
        profileIcon.image = profileImage
        self.profileIcon = profileIcon
        
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = UIFont.systemFont(ofSize: 23)
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.nameLabel = nameLabel
        
        let loginLabel = UILabel()
        loginLabel.text = "@ekaterina_nov"
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        loginLabel.textColor = .gray
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        self.loginLabel = loginLabel
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, World!"
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.textColor = .white
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionLabel = descriptionLabel
        
        let buttonIcon = UIImage(named: "logout_button")
        let logOutButton = UIButton.systemButton(
            with: buttonIcon!,
            target: self,
            action: #selector(Self.didTapLogOutButton)
        )
        logOutButton.tintColor = .red
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(profileIcon)
        view.addSubview(nameLabel)
        view.addSubview(loginLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(logOutButton)
        
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
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "tabBar") else {return}
        present( viewController, animated: false)
    }
}
