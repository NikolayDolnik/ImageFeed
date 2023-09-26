//
//  ProfileViewTest.swift
//  ImageeFeedTests
//
//  Created by Dolnik Nikolay on 24.09.2023.
//

import XCTest
@testable import ImageeFeed

final class ProfileViewTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLogOutCleanToken() throws {
        let presenter = ProfileViewPresenter()
       
        presenter.logOut()
        
        XCTAssertEqual(OAuth2TokenStorage().token, "")
    }
    
    func testUpdateAvatar(){
        let profileImageService = ProfileImageSpy()
        profileImageService.avatarURL = "https://static.wikia.nocookie.net/supcom2/images/3/36/Earth.jpg/revision/latest?cb=20201121171803&path-prefix=ru"
        
        let profileService = ProfileServiceSpy()
        let presenter = ProfileViewPresenter()
        presenter.profileImageService = profileImageService
        
        let profileVC = ProfileViewControllerSpy()
        profileVC.configure(presenter)
        presenter.updateAvatar()
        
        XCTAssertEqual(profileVC.url, URL(string: profileImageService.avatarURL!))
    }
    
    func testUpdateAvatarNil(){
        let presenter = ProfileViewPresenter()
        presenter.profileImageService = ProfileImageSpy()
        let profileVC = ProfileViewControllerSpy()
        profileVC.configure(presenter)
        presenter.updateAvatar()
        
        XCTAssertTrue(profileVC.test)
    }
    
    func testProfileLoad(){
        let profileService = ProfileServiceSpy()
        profileService.profile = Profile(userName: "user", name: "Test", logineName: "Login", bio: "")
        let presenter = ProfileViewPresenter()
        presenter.profileService = profileService
        
        let profileVC = ProfileViewController()
        profileVC.configure(presenter)
        profileVC.loadProfile(presenter.profile())
        
        XCTAssertEqual(profileVC.nameLabel.text, "Test")
    }

}

final class ProfileServiceSpy: ProfileServiceProtocol {
    var profile: Profile?
}

final class ProfileImageSpy: ProfileImageServiceProtocol {
    var avatarURL: String?
}

final class ProfilePresenterSpy: ProfileViewPresenterProtocol {
    var view: ImageeFeed.ProfileViewControllerProtocol?
    
    var profileService: ImageeFeed.ProfileServiceProtocol
    
    var profileImageService: ImageeFeed.ProfileImageServiceProtocol
    
    init(profileService: ImageeFeed.ProfileServiceProtocol,
         profileImageService: ImageeFeed.ProfileImageServiceProtocol
    ) {
        self.profileService = profileService
        self.profileImageService = profileImageService
    }
    
    func logIn() {
         
    }
    
    func logOut() {
         
    }
    
    func updateAvatar() {
         
    }
    
    func profile() -> ImageeFeed.Profile? {
        return profileService.profile
    }
    
    
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    
    var test: Bool = false
    var url: URL?
    var presenter: ImageeFeed.ProfileViewPresenterProtocol?
    
    func configure(_ presenter: ImageeFeed.ProfileViewPresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }
    
    func updateAvatar(from url: URL) {
        self.url = url
    }
    
    func loadProfile(_ profile: ImageeFeed.Profile?) {
        
    }
    
    func updateAvatarError() {
        print("avatar")
        test = true
    }
    
    
}
