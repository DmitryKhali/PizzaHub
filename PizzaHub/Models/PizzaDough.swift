//
//  PizzaDough.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 16.02.2026.
//

import Foundation

enum PizzaDough: String, Codable, CaseIterable, Hashable {
    case traditional = "Традиционное"
    case thin = "Тонкое"
}

extension PizzaDough {
    var displayValue: String {
        rawValue
    }
}
