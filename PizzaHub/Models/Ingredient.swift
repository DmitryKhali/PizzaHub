//
//  Ingredient.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 11.10.2025.
//

import Foundation

struct Ingredient: Codable, Equatable, Hashable {
    let id: String
    let image: String
    let name: String
    let price: Int?
    let required: Bool?
    let isIncluded: Bool?
}

extension Ingredient {
    func withIncludedToggled() -> Ingredient {
        guard let isIncluded else { return self }
        
        return Ingredient(
            id: self.id,
            image: self.image,
            name: self.name,
            price: self.price,
            required: self.required,
            isIncluded: isIncluded ? false : true
        )
    }
}
