//
//  ImageListHelper.swift
//  ImageeFeed
//
//  Created by Dolnik Nikolay on 19.09.2023.
//

import Foundation
import UIKit
import Kingfisher
import ProgressHUD

public protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? {get set}
    var imageListService: ImageListServiceProtocol { get }
    var photos: [Photo] {get}
    func loadPage()
    func nextpage(_ indexPath: IndexPath)
    func newRows() -> [IndexPath]?
    
    func didTapLike(for cell: ImagesListCell, with indexPath: IndexPath)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    weak var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    var imageListService: ImageListServiceProtocol = ImageListService.shared
    private var imageListServiceObserver: NSObjectProtocol?
    // MARK: - Methods
    
    func loadPage(){
        imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImageListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self,
                      let newRows = self.newRows() else { return}
                self.view?.updateTableViewAnimated(newRows)
            }
        imageListService.fetchPhotosNextpage()
    }
    
    func nextpage(_ indexPath: IndexPath){
        if indexPath.row + 1 == photos.count {
            imageListService.fetchPhotosNextpage()
        }
    }
    
    func newRows() ->  [IndexPath]? {
        let newCount = imageListService.photos.count
        let count = photos.count
        guard count != newCount else { return nil }
        photos = imageListService.photos
        var indexPath: [IndexPath] = []
        for i in count..<newCount {
            indexPath.append(IndexPath(row: i, section: 0))
        }
        return indexPath
    }
    
    func didTapLike(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        imageListService.likeChangeReguest(photo: photo) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let photos):
                self.photos = photos
                self.view?.likeResult(for: cell, with: indexPath)
            case .failure:
                self.view?.likeError(for: cell, with: indexPath)
            }
        }
    }
    
}

