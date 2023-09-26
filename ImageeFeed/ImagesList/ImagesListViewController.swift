//
//  ViewController.swift
//  ImageeFeed
//
//  Created by Dolnik Nikolay on 29.04.2023.
//

import UIKit
import Kingfisher
import ProgressHUD

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? {get set}
    func updateTableViewAnimated(_ newRows: [IndexPath])
    func likeResult(for cell: ImagesListCell, with indexPath: IndexPath)
    func likeError(for cell: ImagesListCell, with indexPath: IndexPath)
}


class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    
      // MARK: - Properties
    
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    var presenter: ImagesListPresenterProtocol?
    
    @IBOutlet private var tableView: UITableView!
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
        configure(ImagesListPresenter())
        presenter?.loadPage()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
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
    
    func configure(_ presenter: ImagesListPresenterProtocol){
        self.presenter = presenter
        self.presenter?.view = self
    }
    
}

//MARK: - Methods

extension ImagesListViewController {
    
    func updateTableViewAnimated(_ newRows: [IndexPath]){
            tableView.performBatchUpdates{
                self.tableView.insertRows(at: newRows, with: .automatic)
            } completion: {_ in }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       presenter?.nextpage(indexPath)
    }
    
    func configCellImageSerivce(for cell: ImagesListCell, with indexPath: IndexPath){
        
        guard let photo: Photo = presenter?.photos[indexPath.row],
        let image = UIImage(named: "scribble"),
        let url = URL(string: photo.thumbImageURl) else { return }
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
        cell.setIsLike(like: !photo.isLiked)
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    
    func imageListCellDidTapLike(_ cell: ImagesListCell){
        guard let indexPath = tableView.indexPath(for: cell),
              let photo = presenter?.photos[indexPath.row] else { return }
        cell.setIsLike(like: photo.isLiked)
        UIBlockingProgressHUD.show()
        presenter?.didTapLike(for: cell, with: indexPath)
    }
    
    func likeResult(for cell: ImagesListCell, with indexPath: IndexPath) {
        UIBlockingProgressHUD.dismiss()
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func likeError(for cell: ImagesListCell, with indexPath: IndexPath) {
        UIBlockingProgressHUD.dismiss()
        guard let photo = presenter?.photos[indexPath.row] else { return }
            cell.setIsLike(like: !photo.isLiked)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            self.showAlert(title: "«Что-то пошло не так(»",
                           message: "«Не удалось cохранить лайк»",
                           actions: [UIAlertAction(title: "ОК", style: .default, handler: nil)]
                           )
    }
}


extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let largeImageUrl = presenter?.photos[indexPath.row].largeImgaeURL
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: largeImageUrl)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        guard let photo: Photo = presenter?.photos[indexPath.row] else { return 120}
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
        return presenter?.photos.count ?? 0
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
