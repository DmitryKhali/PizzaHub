//
//  UIButton+Order.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 27.02.2026.
//

import UIKit

extension UIButton {
    func updateOrderButton(totalPrice: Int) {
        var config = configuration ?? .filled()
        
        let newTitle = AttributedString("Оформить заказ на \(totalPrice) ₽", attributes: AttributeContainer([
            .font: UIFont.systemFont(ofSize: 16, weight: .bold)
        ]))
        
        config.attributedTitle = newTitle
        configuration = config
    }
    
    func updateAddToCartButton(totalPrice: Int) {
        var config = configuration ?? .filled()
        
        let newTitle = AttributedString("В корзину за \(totalPrice) ₽", attributes: AttributeContainer([
            .font: UIFont.systemFont(ofSize: 16, weight: .bold)
        ]))
        
        config.attributedTitle = newTitle
        configuration = config
    }
}
