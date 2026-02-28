//
//  PizzaSize.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 16.02.2026.
//

import Foundation

enum PizzaSize: Int, Codable, CaseIterable, Hashable {
    case small = 20
    case medium = 25
    case large = 30
    case extraLarge = 35
}

extension PizzaSize {
    var displayValue: String {
        "\(rawValue) см"
    }
}

extension PizzaSize {
    var priceMultiplier: Double {
        switch self {
        case .small: return 0.8
        case .medium: return 1.0
        case .large: return 1.3
        case .extraLarge: return 1.7
        }
    }
}
