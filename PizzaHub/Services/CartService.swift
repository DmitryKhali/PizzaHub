//
//  CartService.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 16.01.2026.
//

import Foundation

protocol ICartService {
    func addToCart(_ product: Product)
    func removeFromCart(_ product: Product)
    func getCartItems() -> [Product]
    func updateQuantity(for product: Product, with newQuantity: Int)
    func updateProductInCart(with baseProduct: Product, updatedProduct: Product)
    
    func getTotalItemsCount() -> Int
    func getTotalPrice() -> Int
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
        queue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            var cart = self.readFromUserDefaults()
            
            if let index = cart.firstIndex(where: { $0 == product }) {
                cart[index] = product.changeQuantity(with: (cart[index].quantity ?? 1) + 1)
            }
            else {
                cart.append(product.changeQuantity(with: 1))
            }
            
            self.save(cart)
        }
    }
    
    func removeFromCart(_ product: Product) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            var cart = self.readFromUserDefaults()
            
            if let index = cart.firstIndex(where: { $0 == product }) {
                if product.quantity ?? 1 <= 1 {
                    cart.remove(at: index)
                }
                else {
                    cart[index] = product.changeQuantity(with: product.quantity ?? 1 - 1) // TODO: сюда возможно попасть?
                }
            }
            
            self.save(cart)
        }
    }
    
    func getCartItems() -> [Product] {
        queue.sync {
            readFromUserDefaults()
        }
    }
    
    func updateQuantity(for product: Product, with newQuantity: Int) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            var cart = readFromUserDefaults()
            
            guard let index = cart.firstIndex(where: { $0 == product }) else { return }
            cart[index] = product.changeQuantity(with: newQuantity)
            
            save(cart)
        }
    }
    
    func getTotalItemsCount() -> Int {
        return readFromUserDefaults().reduce(0) { partialResult, product in
            return partialResult + (product.quantity ?? 1)
        }
    }
    
    func getTotalPrice() -> Int {
        return readFromUserDefaults().reduce(0) { partialResult, product in
            return partialResult + (product.totalPrice * (product.quantity ?? 1))
        }
    }
    
    func updateProductInCart(with baseProduct: Product, updatedProduct: Product) {
        queue.asyncAndWait(flags: .barrier) { [weak self] in
            guard let self else { return }
            var cart = readFromUserDefaults()
            
            guard let index = cart.firstIndex(where: { $0 == baseProduct }) else { return }
            cart[index] = updatedProduct
            
            save(mergeDuplicates(in: cart))
        }
    }
}

// MARK: private
extension CartService {
    
    private func readFromUserDefaults() -> [Product] {
        guard let data = userDefaults.data(forKey: key) else { return [] }
        
        do {
            let products = try decoder.decode([Product].self, from: data)
            return products
        }
        catch {
            print(error)
        }
        
        return []
    }
    
    private func save(_ cart: [Product]) {
        do {
            let data = try self.encoder.encode(cart)
            self.userDefaults.set(data, forKey: key)
        }
        catch {
            print("")
        }
    }
    
    private func mergeDuplicates(in products: [Product]) -> [Product] {
        
        var result: [Product] = []
        
        for product in products {
            if let index = result.firstIndex(where: { $0 == product }) {
                result[index] = result[index].changeQuantity(with: (result[index].quantity ?? 1) + (product.quantity ?? 1))
            }
            else {
                result.append(product)
            }
        }
        
        return result
    }
}
