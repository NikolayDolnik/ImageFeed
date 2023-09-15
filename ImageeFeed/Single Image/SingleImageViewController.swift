//
//  SingleImageViewController.swift
//  ImageeFeed
//
//  Created by Dolnik Nikolay on 23.05.2023.
//

import UIKit
import Kingfisher
import ProgressHUD

final class SingleImageViewController: UIViewController {
    
    var imageUrl: String?
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            rescaleAndCenterImageInScrollView(image: image)
        }
    }

    // MARK: - IBOutlet & IBOaction
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var scrollView: UIScrollView!
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true,completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }

    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }
    
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

// MARK: - Private Methods

extension SingleImageViewController {
    private func loadImage(){
        UIBlockingProgressHUD.show()
        guard imageUrl != nil, let url = URL(string: imageUrl!), let img = UIImage(named: "scribble") else { return}
        imageView.image = img
        self.rescaleAndCenterImageInScrollView(image: img)
        imageView.kf.setImage(with: url){ [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else {return}
            switch result{
            case .success(let imageResult):
                self.image = imageResult.image
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showError()
            }
        }
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
}

extension SingleImageViewController {
    private func showError() {
        let alert = UIAlertController(
            title: "«Что-то пошло не так(»",
            message: "«Попробовать еще раз?»",
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: "Не надо",
                style: .default
            )
        )
        alert.addAction(
            UIAlertAction(
                title: "Повторить",
                style: .default
                ) { _ in
                    self.loadImage()
                }
        )
        present(alert, animated: true)
    }
}
