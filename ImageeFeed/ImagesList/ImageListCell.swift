//
//  ImageListCell.swift
//  ImageeFeed
//
//  Created by Dolnik Nikolay on 05.05.2023.
//

import UIKit
import Kingfisher

class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    override func prepareForReuse() {
        cellImage.kf.cancelDownloadTask()
    }

}
