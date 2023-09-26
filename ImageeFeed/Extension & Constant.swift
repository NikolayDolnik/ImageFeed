//
//  Extension & Constant.swift
//  ImageeFeed
//
//  Created by Dolnik Nikolay on 19.09.2023.
//

import Foundation
import UIKit



extension UIColor {
    static let ypBlack = UIColor(named: "YP Black")
}


extension UIViewController {
    func showAlert(title: String, message: String, actions: [UIAlertAction]?) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        guard let actions = actions else { return self.present(alert, animated: true) }
        for action in actions {
            alert.addAction(action)
        }
        self.present(alert, animated: true)
    }
}
