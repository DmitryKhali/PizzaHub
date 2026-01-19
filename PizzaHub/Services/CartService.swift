//
//  CartService.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 16.01.2026.
//

import Foundation

protocol ICartService {
    func addToCart(_ product: Product, quantiy: Int)
    func removeFromCart(_ product: Product)
    func updateQuantity(_ product: Product, quantity: Int)
//    func getCartItems() -> [CartItem]
}

final class CartService: ICartService {
    func addToCart(_ product: Product, quantiy: Int) {
        //
    }
    
    func removeFromCart(_ product: Product) {
        //
    }
    
    func updateQuantity(_ product: Product, quantity: Int) {
        //
    }
    
    private let userDefaults: UserDefaults
    private let key: String
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    init(
        userDefaults: UserDefaults = .standard,
         key: String = "dodo.app.products",
         encoder: JSONEncoder = JSONEncoder(),
         decoder: JSONDecoder = JSONDecoder()
    ) {
        self.userDefaults = userDefaults
        self.key = key
        self.encoder = encoder
        self.decoder = decoder
    }
        
    func save(_ products: [Product]) {
        do {
            let data = try encoder.encode(products)
            userDefaults.set(data, forKey: key)
        }
        catch {
            print(error)
        }
    }
    
    func retrieve() -> [Product] {
        guard let data = userDefaults.data(forKey: key) else { return [] }
        
        do {
            let array = try decoder.decode([Product].self, from: data)
            return array
        }
        catch {
            print(error)
        }
        
        return []
    }
}
