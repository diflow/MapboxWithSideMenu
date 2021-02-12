//
//  UIViewController+Extension.swift
//  MapboxWithSideMenu
//
//  Created by ivan on 12.02.2021.
//

import UIKit

extension UIViewController {

  
    func showAlert(withTitle title: String, withMessage message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okButton)
        present(alertController, animated: true)
    }
    
    func showDismissAlert(withTitle title: String, message: String, cancelBlock: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            cancelBlock?()
        }
        let dismissAction = UIAlertAction(title: "Закрыть", style: .destructive) { (_) in
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }

        for action in [okAction, dismissAction] {
            alertController.addAction(action)
        }
        present(alertController, animated: true, completion: nil)
    }
}
