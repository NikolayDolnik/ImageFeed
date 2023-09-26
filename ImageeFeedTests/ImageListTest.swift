//
//  ImageListTest.swift
//  ImageeFeedTests
//
//  Created by Dolnik Nikolay on 21.09.2023.
//

import XCTest
@testable import ImageeFeed

final class ImageListTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testloadPage() throws {
        let service = ImageListServiceSpy(photos: [])
        let presenter = ImagesListPresenter()
        presenter.imageListService = service
        
        presenter.loadPage()
        
        XCTAssertTrue(service.test)
    }

    func testNewRowsAddNil() throws {
        let service = ImageListServiceSpy(photos: [])
        let presenter = ImageListPresenterSpy(imageListService: service)
        
        let newRows = presenter.newRows()
        
        XCTAssertNil(newRows)
    }
    
    func testNewRowsAdd() throws {
        let service = ImageListServiceSpy(photos: [photoTest, photoTest])
        let presenter = ImagesListPresenter()
        presenter.imageListService = service
        
        let newRows = presenter.newRows()
        
        XCTAssertEqual(2, newRows?.count)
    }
    
    func testNextPage() throws {
        let service = ImageListServiceSpy(photos: [photoTest, photoTest])
        let presenter = ImagesListPresenter()
        presenter.photos =  [photoTest, photoTest]
        presenter.imageListService = service
        let index = IndexPath(row: 1, section: 0)
       
        presenter.nextpage(index)
        
        XCTAssertTrue(service.test)
    }
    
    func testDidTapLike() throws {
        let service = ImageListServiceSpy(photos: [photoTest, photoTest])
        let presenter = ImagesListPresenter()
        presenter.imageListService = service
        presenter.photos = service.photos
        let cell = ImagesListCell()
        let index = IndexPath(row: 0, section: 0)
        
        presenter.didTapLike(for: cell, with: index)
        let test = service.photos[1].isLiked

        XCTAssertTrue(test)
    }

}

final class ImageListPresenterSpy: ImagesListPresenterProtocol {
    var imageListService: ImageeFeed.ImageListServiceProtocol
    
    var photos: [ImageeFeed.Photo] = []
    var view: ImageeFeed.ImagesListViewControllerProtocol?
    var test: Bool = false
    init(imageListService: ImageListServiceProtocol ){
        self.imageListService = imageListService
    }
    
    func loadPage() {
        
    }
    
    func nextpage(_ indexPath: IndexPath) {
    
    }
    
    func newRows() -> [IndexPath]? {
        test = true
        return nil
    }
    
    func didTapLike(for cell: ImageeFeed.ImagesListCell, with indexPath: IndexPath) {
    
    }
    
    
}


final class ImageListServiceSpy: ImageListServiceProtocol {
    var photos: [ImageeFeed.Photo]
    var test: Bool = false
    
    init(photos: [ImageeFeed.Photo]) {
        self.photos = photos
    }
    
    func fetchPhotosNextpage() {
         test = true
    }
    
    func likeChangeReguest(photo: ImageeFeed.Photo, completion: @escaping (Result<[ImageeFeed.Photo], Error>) -> Void) {
        var photo = photos[1]
        photo.isLiked = false
    }
    
    
}


let photoTest = Photo(
    id: "Id",
    size: CGSize(width: 2448, height: 3264),
    createdAt: Date(),
    welcomeDescription: "",
    thumbImageURl: "https://images.unsplash.com/photo-1417325384643-aac51acc9e5d?q=75&fm=jpg&w=200&fit=max", largeImgaeURL: "https://images.unsplash.com/photo-1417325384643-aac51acc9e5d?q=75&fm=jpg",
    isLiked: true)
