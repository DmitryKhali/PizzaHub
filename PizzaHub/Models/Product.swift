//
//  Product.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 11.10.2025.
//

import Foundation

struct Product: Codable, Equatable, Hashable {
    let id: String
    let category: String
    let name: String
    let detail: String
    let basePrice: Int
    let image: String
    let size: PizzaSize?
    let dough: PizzaDough?
    let baseIngredients: [Ingredient]?
    let additionalIngredients: [Ingredient]? 
    let weight: Int?
    let quantity: Int?
}

extension Product {
    var minimumPrice: Int {
        Int(Double(basePrice) * PizzaSize.small.priceMultiplier)
    }
    
    var currentPrice: Int {
        let multiplier = size?.priceMultiplier ?? 1.0
        return Int(Double(basePrice) * multiplier)
    }
    
    var totalPrice: Int {
        let ingredientsPrice = additionalIngredients?.reduce(0, { $0 + ($1.price ?? 0) }) ?? 0
        return currentPrice + ingredientsPrice
    }
}

extension Product {
    var selectedAdditionalIngredientsIds: Set<String> {
        guard let ingredients = additionalIngredients else { return [] }
        return Set(ingredients.map{ $0.id })
    }
}

extension Product {
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id &&
        lhs.size == rhs.size &&
        lhs.dough == rhs.dough &&
        lhs.baseIngredients == rhs.baseIngredients &&
        lhs.additionalIngredients == rhs.additionalIngredients
    }
}

extension Product {
    func changeSize(_ newSize: PizzaSize) -> Product {
        Product(
            id: self.id,
            category: self.category,
            name: self.name,
            detail: self.detail,
            basePrice: self.basePrice,
            image: self.image,
            size: newSize,
            dough: self.dough,
            baseIngredients: self.baseIngredients,
            additionalIngredients: self.additionalIngredients,
            weight: self.weight,
            quantity: self.quantity
        )
    }
    
    func changeDough(_ newDough: PizzaDough) -> Product {
        Product(
            id: self.id,
            category: self.category,
            name: self.name,
            detail: self.detail,
            basePrice: self.basePrice,
            image: self.image,
            size: self.size,
            dough: newDough,
            baseIngredients: self.baseIngredients,
            additionalIngredients: self.additionalIngredients,
            weight: self.weight,
            quantity: self.quantity
        )
    }
    
    func changeBaseIngredients(with ingredients: [Ingredient]) -> Product {
        Product(
            id: self.id,
            category: self.category,
            name: self.name,
            detail: self.detail,
            basePrice: self.basePrice,
            image: self.image,
            size: self.size,
            dough: self.dough,
            baseIngredients: ingredients,
            additionalIngredients: self.additionalIngredients,
            weight: self.weight,
            quantity: self.quantity
        )
    }
    
    func updateAdditionalIngredients(with ingredients: [Ingredient]) -> Product {
        return Product(
            id: self.id,
            category: self.category,
            name: self.name,
            detail: self.detail,
            basePrice: self.basePrice,
            image: self.image,
            size: self.size,
            dough: self.dough,
            baseIngredients: self.baseIngredients,
            additionalIngredients: ingredients.isEmpty ? nil : ingredients,
            weight: self.weight,
            quantity: self.quantity
        )
    }
    
    func changeQuantity(with newQuantity: Int) -> Product {
        Product(
            id: self.id,
            category: self.category,
            name: self.name,
            detail: self.detail,
            basePrice: self.basePrice,
            image: self.image,
            size: self.size,
            dough: self.dough,
            baseIngredients: self.baseIngredients,
            additionalIngredients: self.additionalIngredients,
            weight: self.weight,
            quantity: newQuantity
        )
    }
}
