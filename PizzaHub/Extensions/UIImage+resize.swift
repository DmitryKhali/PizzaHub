//
//  UIImage+resize.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 25.01.2026.
//

import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
