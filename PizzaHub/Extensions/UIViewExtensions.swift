//
//  UIViewExtensions.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 12.10.2025.
//

import UIKit

extension UIView {
    func applyShadow(cornerRadius: CGFloat, shadowRadius: CGFloat = 4.0, shadowOpacity: Float = 0.3) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}
