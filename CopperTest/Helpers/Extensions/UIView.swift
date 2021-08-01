//
//  UIView.swift
//  CopperTest
//
//  Created by Muhammad Ahad on 31/07/2021.
//

import UIKit

extension UIView {
    func roundView(_ cornerRadius:CGFloat? = 0, borderWidth:CGFloat? = 0, borderColor: UIColor? = nil) {
        if let cornerRadius = cornerRadius {
            self.layer.cornerRadius = cornerRadius
        }
        if let borderWidth = borderWidth {
            self.layer.borderWidth = borderWidth
        }
        if let borderColor = borderColor {
            self.layer.borderColor = borderColor.cgColor
        }
        self.layer.masksToBounds = true
    }
}
