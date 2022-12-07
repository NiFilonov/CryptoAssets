//
//  UIViewController+UIAlertViewController.swift
//  CryptoAssets
//
//  Created by Globus Dev on 24.12.2022.
//

import UIKit

protocol ErrorViewingProtocol {
    func showError(title: String?, message: String?)
}

extension UIViewController {
    
    func showError(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.Alert.ok, style: .default))
        present(alert, animated: true)
    }
    
}
