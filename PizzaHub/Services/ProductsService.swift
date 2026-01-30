//
//  ProductsService.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 11.10.2025.
//

import Foundation

protocol IProductsService {
    func fetchProducts() async throws -> [Product]
}

class ProductsService: IProductsService {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }
    
    func fetchProducts() async throws -> [Product] {
        
        guard let url = URL(string: "http://localhost:3000/products") else {
            throw NetworkError.invalidURL
        }
        
        let request = URLRequest(url: url)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.statusCode
        }
        
        let products = try decoder.decode([Product].self, from: data)
        return products
    }
    
}
