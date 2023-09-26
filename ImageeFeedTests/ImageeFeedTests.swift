//
//  ImageeFeedTests.swift
//  ImageeFeedTests
//
//  Created by Dolnik Nikolay on 29.04.2023.
//

import XCTest
@testable import ImageeFeed

final class WebViewTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testViewControllerCallsViewDidLoad(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "WebViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest(){
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let vc = WebViewControllerSpy()
        vc.presenter = presenter
        presenter.view = vc
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(vc.loadRequestCalled)
    }
    
    func testProgressVisibleWhenLessThenOne(){
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let value: Float = 0.789
        XCTAssertFalse( presenter.shouldHideProgress(for: value))
    }
    
    func testProgressHiddenWhenOne(){
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let value: Float = 1
        XCTAssertTrue( presenter.shouldHideProgress(for: value))
    }
    
    func testCodeFromUrl(){
        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString + "/native")!
        urlComponents.queryItems = [
            URLQueryItem(name: "code", value: "code test"),
         ]
        let authHelper = AuthHelper()
        XCTAssertEqual(authHelper.code(from: urlComponents.url!) , "code test")
    }
    
}

final class WebViewControllerSpy: WebViewViewControllerProtocol {
    var loadRequestCalled: Bool = false
    var presenter: ImageeFeed.WebViewPresenterProtocol?
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
    
}


final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: ImageeFeed.WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
    
    
}
