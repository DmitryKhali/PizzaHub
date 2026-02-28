//
//  String+width.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 19.02.2026.
//

import UIKit

extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
