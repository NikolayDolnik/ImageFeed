//
//  ViewController.swift
//  ImageeFeed
//
//  Created by Dolnik Nikolay on 29.04.2023.
//

import UIKit
import Kingfisher
import ProgressHUD


class ImagesListViewController: UIViewController {
    
      // MARK: - Properties
    
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    private let imageListService = ImageListService.shared
    private var imageListServiceObserver: NSObjectProtocol?
    private var photos: [Photo] = []
    
    @IBOutlet private var tableView: UITableView!
    
    private let photosName: [String] = Array(0..<20).map{"\($0)"}
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB")
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImageListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self else {return}
                self.updateTableViewAnimated()
            }
        imageListService.fetchPhotosNextpage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let largeImageUrl = sender as! String
            viewController.imageUrl = largeImageUrl
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
}

//MARK: - Загрузка фотографий из сети

extension ImagesListViewController {
    
    func updateTableViewAnimated(){
        let count = photos.count
        let newCount = imageListService.photos.count
        
        if count != newCount {
            self.photos = imageListService.photos
            var indexPath: [IndexPath] = []
            for i in count..<newCount {
                indexPath.append(IndexPath(row: i, section: 0))
            }
            tableView.performBatchUpdates{
                self.tableView.insertRows(at: indexPath, with: .automatic)
            } completion: {_ in }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imageListService.fetchPhotosNextpage()
        }
    }
    
    func configCellImageSerivce(for cell: ImagesListCell, with indexPath: IndexPath){
        
        let photo: Photo = photos[indexPath.row]
        let image = UIImage(named: "scribble")
        guard let url = URL(string: photo.thumbImageURl) else { return}
        if let createdAd = photo.createdAt {
            cell.dateLabel.text = dateFormatter.string(from: createdAd)
        } else {
            cell.dateLabel.text = ""
        }
        cell.delegate = self
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.indicator?.startAnimatingView()
        cell.cellImage.kf.setImage(with: url, placeholder: image ){ _ in
            cell.cellImage.kf.indicator?.stopAnimatingView()
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        let likeImage = photo.isLiked ? UIImage(named: "Favorites Active") : UIImage(named: "Favorites No Active")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        cell.setIsLike(like: photo.isLiked)
        imageListService.likeChangeReguest(photo: photo) { [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let photos):
                self.photos = photos
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                cell.setIsLike(like: !photo.isLiked)
                self.showAlert()
            }
        }
    }
}


extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let largeImageUrl = photos[indexPath.row].largeImgaeURL
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: largeImageUrl)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let photo: Photo = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
        
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCellImageSerivce(for: imageListCell, with: indexPath)
        return imageListCell
    }
}


extension ImagesListViewController {
    func showAlert() {
        let alert = UIAlertController(
            title: "«Что-то пошло не так(»",
            message: "«Не удалось cохранить лайк»",
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(title: "ОК", style: .default, handler: nil
                         ))
        present(alert, animated: true)
    }
}

