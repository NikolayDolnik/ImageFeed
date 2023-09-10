//
//  ViewController.swift
//  ImageeFeed
//
//  Created by Dolnik Nikolay on 29.04.2023.
//

import UIKit
import Kingfisher

class ImagesListViewController: UIViewController {
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    private let imageListService = ImageListService.shared
    private var imageListServiceObserver: NSObjectProtocol?
    private var photos: [Photo] = []

    @IBOutlet private var tableView: UITableView!
    
    private let photosName: [String] = Array(0..<20).map{"\($0)"}
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImageListService.DidChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self else {return}
                self.updateTableViewAnimated()
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == ShowSingleImageSegueIdentifier {
               let viewController = segue.destination as! SingleImageViewController
               let indexPath = sender as! IndexPath
               let image = UIImage(named: photosName[indexPath.row])
               viewController.image = image
           } else {
               super.prepare(for: segue, sender: sender)
           }
       }

}

//MARK: - Загрузка фотографий из сети

extension ImagesListViewController {
    
    func updateTableViewAnimated(){
        //вызывается по нотификации и обновляет состояние таблицы
        let count = photos.count
        let newCount = imageListService.photos.count
        self.photos = imageListService.photos
        
        if count != newCount {
            //добавляем новые ячейки
            tableView.performBatchUpdates{
                var indexPath: [IndexPath] = []
                for i in count..<newCount {
                    indexPath.append(IndexPath(row: i, section: 0))
                    }
                self.tableView.insertRows(at: indexPath, with: .automatic)
            } completion: {_ in }
        }
    }
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         //Проверить условие последней ячейки и вызывать fetchPhotos.. если индекс последняя строка в таблице
         if indexPath.row + 1 == photos.count {
             imageListService.fetchPhotosNextpage { [weak self] result in
                 guard let self = self else {return print("ошибка TableView")}
                 switch result {
                 case .success:
                     print("Страничка загружена")
                 case .failure:
                     let alert = UIAlertController(title: "«Что-то пошло не так(»", message: "«Не удалось загрузить ленту»", preferredStyle: .alert)
                     alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
                     self.present(alert, animated: true)
                 }
             }
         }
         // если ячейка не последняя нужен ли else {return}
     }
    
    func configCellImageSerivce(for cell: ImagesListCell, with indexPath: IndexPath){
        // TODO: - поменять функцию конфигурации ячейки из др массива
        let photo: Photo = photos[indexPath.row]
        guard let url = URL(string: photo.thumbImageURl)
        else {
            guard let image = UIImage(named: "scribble") else {
                return
            }
            return  }
        cell.cellImage.image.kf.setImage(with: url)
        cell.dateLabel.text = photo.createdAt ?? ""
        cell.likeButton.setImage(icon(), for: .normal)
        
        func icon(){
            guard let buttonIcon = (photo.isLiked ? UIImage(named: "Favorites Active") : UIImage(named: "Favorites No Active")) else { return UIImage(named: "Favorites Active") }
            return buttonIcon
        }
    }
    
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath){

        guard let image = UIImage(named: "\(indexPath.row)") else {
            return
        }
        
        func icon()-> UIImage? {
            guard let buttonIcon = (indexPath.row % 2 == 0 ? UIImage(named: "Favorites Active") : UIImage(named: "Favorites No Active")) else { return UIImage(named: "Favorites Active") }
            return buttonIcon
        }
        cell.cellImage.image = image
        cell.dateLabel.text = dateFormatter.string(from: Date())
        cell.likeButton.setImage(icon(), for: .normal)
        }
}


extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //TODO: - поменять название массива
        let photo: Photo = photos[indexPath.row]
        guard let url = URL(string: photo.thumbImageURl)
        else {
            guard let image = UIImage(named: "scribble") else {
                return 0
            }
            return  }
        let image = UIImage.kf.setImage(with: url)
       /*
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        */
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: - заменить количество ячеек
        return photos.count // photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        // TODO: - поменять функцию конфигурации ячейки из др массива
         configCellImageSerivce(for cell: imageListCell, with: indexPath)
        //configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}


