//
//  CartService.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 16.01.2026.
//

import Foundation

struct CartItem: Codable, Equatable {
    let product: Product
    let quantity: Int
    
    var id: String { product.id }
}

protocol ICartService {
    func addToCart(_ product: Product)
    func removeFromCart(_ product: Product)
    func getCartItems() -> [CartItem]
}

final class CartService: ICartService {
    private let userDefaults: UserDefaults
    private let key: String
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let queue = DispatchQueue(label: "cart.queue", attributes: .concurrent)
        
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
}

// MARK: public
extension CartService {
    func addToCart(_ product: Product) {
        var cart = getCartItems()
        
        if let index = cart.firstIndex(where: { $0.id == product.id }) {
            cart[index] = CartItem(product: product, quantity: cart[index].quantity + 1)
        }
        else {
            cart.append(CartItem(product: product, quantity: 1))
        }
        
        save(cart)
    }
    
    func removeFromCart(_ product: Product) {
        var cart = getCartItems()
        
        if let index = cart.firstIndex(where: { $0.id == product.id }) {
            if cart[index].quantity <= 1 {
                cart.remove(at: index)
            }
            else {
                cart[index] = CartItem(product: product, quantity: cart[index].quantity - 1)
            }
        }
        
        save(cart)
    }
    
    func getCartItems() -> [CartItem] {
        guard let data = userDefaults.data(forKey: key) else { return [] }
        
        do {
            let array = try decoder.decode([CartItem].self, from: data)
            return array
        }
        catch {
            print(error)
        }
        
        return []
    }
}

// MARK: private
extension CartService {
    
    
    private func save(_ cart: [CartItem]) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            do {
                let data = try self.encoder.encode(cart)
                self.userDefaults.set(data, forKey: key)
            }
            catch {
                print("")
            }
        }
    }
}
