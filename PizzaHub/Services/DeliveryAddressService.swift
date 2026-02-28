//
//  DeliveryAddressService.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 15.02.2026.
//

import Foundation

protocol IDeliveryAddressService {
    func add(_ address: String)
    func remove(_ address: String)
    func getAll() -> [String]
}

final class DeliveryAddressService {
    private let userDefaults: UserDefaults
    private let key: String
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let queue = DispatchQueue(label: "deliveryAddresses.queue", attributes: .concurrent)
        
    init(
        userDefaults: UserDefaults = .standard,
         key: String = "dodo.app.deliveryAddresses",
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
extension DeliveryAddressService: IDeliveryAddressService {
    func add(_ address: String) {
        var cart = getAll()
        
//        if let index = cart.firstIndex(where: { $0.id == product.id }) {
//            cart[index] = CartItem(product: product, quantity: cart[index].quantity + 1)
//        }
//        else {
//            cart.append(CartItem(product: product, quantity: 1))
//        }
//        
//        save(cart)
    }
    
    func remove(_ address: String) {
        var cart = getAll()
        
//        if let index = cart.firstIndex(where: { $0.id == product.id }) {
//            if cart[index].quantity <= 1 {
//                cart.remove(at: index)
//            }
//            else {
//                cart[index] = CartItem(product: product, quantity: cart[index].quantity - 1)
//            }
//        }
        
        save(cart)
    }
    
    func getAll() -> [String] {
        guard let data = userDefaults.data(forKey: key) else { return [] }
        
//        do {
//            let array = try decoder.decode([CartItem].self, from: data)
//            return array
//        }
//        catch {
//            print(error)
//        }
        
        return []
    }
}

// MARK: private
extension DeliveryAddressService {
    private func save(_ cart: [String]) {
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
