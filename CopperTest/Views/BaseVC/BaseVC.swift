//
//  BaseVC.swift
//  CopperTest
//
//  Created by Muhammad Ahad on 31/07/2021.
//

import UIKit
import JGProgressHUD

class BaseVC: UIViewController {
    
    private lazy var progressHUD = JGProgressHUD()
    
    func showProgressHUD(text: String = Constants.StringDef.pleaseWait) {
        DispatchQueue.main.async {
            self.progressHUD.textLabel.text = text
            self.progressHUD.show(in: self.view)
        }
    }
    
    func hideProgressHUD() {
        DispatchQueue.main.async {
            self.progressHUD.dismiss()
        }
    }
    
    //MARK:- Show alert
    func showAlert(_ title: String? = nil,
                    message: String,
                   action: UIAlertAction? = nil,
                   secondAction: UIAlertAction? = nil) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let alertController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)
            
            alertController.addAction(action ?? UIAlertAction(title: "OK", style: .default, handler: nil))
            
            if let secondAction = secondAction {
                alertController.addAction(secondAction)
            }
            
//            let titleFont = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
//            let messageFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
//
//            let titleAttrString = NSMutableAttributedString(string: title ?? "", attributes: titleFont)
//            let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
//
//            alertController.setValue(titleAttrString, forKey: "attributedTitle")
//            alertController.setValue(messageAttrString, forKey: "attributedMessage")
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
