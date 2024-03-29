//
//  ImageeFeedUITests.swift
//  ImageeFeedUITests
//
//  Created by Dolnik Nikolay on 29.04.2023.
//

import XCTest

final class ImageeFeedUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }


    func testAuth() throws {
        
        app.buttons["Authenticate"].tap()
        let webView = app.webViews["WebViewController"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        loginTextField.tap()
        loginTextField.typeText("dolnik.nikolo@gmail.com")
        XCUIApplication().toolbars.buttons["Done"].tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 3))
        passwordTextField.tap()
        passwordTextField.typeText("dolnik94")
        XCUIApplication().toolbars.buttons["Done"].tap()
        
        let buttonLogin = webView.descendants(matching: .button).element
        XCTAssertTrue(buttonLogin.waitForExistence(timeout: 3))
        buttonLogin.tap()
        print(app.debugDescription)
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }

    func testFeed() throws {
        let tabBarView = app.tabBars.element
        XCTAssertTrue(tabBarView.waitForExistence(timeout: 5))
        
        let tablesQuery = app.tables
        app.swipeUp()
        app.swipeDown()
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        let likeButton = cell.buttons.element
        likeButton.tap()
        sleep(3)
        likeButton.tap()
        sleep(3)
        cell.tap()
        sleep(5)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let back = app.buttons["back"]
        back.tap()
        
        
    }
    
    func testProfile() throws {

        sleep(2)
        let profile = app.tabBars.buttons.element(boundBy: 1)
        profile.tap()

        let login = app.staticTexts["@dolnik_nikolo"].exists
        let name = app.staticTexts["Nikolai Dolnik"].exists
        XCTAssertTrue(login)
        XCTAssertTrue(name)

        let logOut = app.buttons["logout_button"]
        logOut.tap()
        app.alerts["«Пока, пока!»"].scrollViews.otherElements.buttons["Да"].tap()
        sleep(2)
        XCTAssertTrue(app.buttons["Authenticate"].exists)
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
}
