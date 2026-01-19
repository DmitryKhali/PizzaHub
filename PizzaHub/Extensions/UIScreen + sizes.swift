//
//  UIScreen + sizes.swift
//  SampleApp
//
//  Created by Dmitry Khalitov on 02.11.2025.
//

import UIKit

extension UIScreen {
    static var current: UIScreen? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.screen
    }
    
    static var currentWidth: CGFloat {
        current?.bounds.width ?? 0
    }
    
    static var currentHeight: CGFloat {
        current?.bounds.height ?? 0
    }
}
