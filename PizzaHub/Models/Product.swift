//
//  Product.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 11.10.2025.
//

import Foundation

struct Product: Codable, Equatable {
    var id: String
    var name: String
    var detail: String
    var price: Int
    var image: String
}
