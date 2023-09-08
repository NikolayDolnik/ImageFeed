//
//  ViewController.swift
//  ImageeFeed
//
//  Created by Dolnik Nikolay on 29.04.2023.
//

import UIKit

class ImagesListViewController: UIViewController {
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
   // private let imageListService = ImageListService()
    private var photos: [Photo] = [] // массив загруженных фото

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
        // Do any additional setup after loading the view.
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
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
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        
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
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
   /*
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //Проверить условие последней ячейки и вызывать fetchPhotos..
        if indexPath.row + 1 == photos.count {
            imageListService.fetchPhotosNextpage { [weak self] result in
                guard let self = self else {return print("ошибка TableView")}
                switch result {
                case .success( let photo):
                    self.photos = photo
                case .failure:
                    let alert = UIAlertController(title: "«Что-то пошло не так(»", message: "«Не удалось загрузить ленту»", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        } else {
            return // если ячейка не последняя
        }
    }
    */
}


