//
//  ImageListCell.swift
//  ImageeFeed
//
//  Created by Dolnik Nikolay on 05.05.2023.
//

import UIKit
import Kingfisher

public final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    @IBAction private func LikeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLike(like: Bool) {
        likeButton.setImage(!like ? UIImage(named: "Favorites Active") : UIImage(named: "Favorites No Active"), for: .normal)
    }
    
    public override func prepareForReuse() {
        cellImage.kf.cancelDownloadTask()
    }
}

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
