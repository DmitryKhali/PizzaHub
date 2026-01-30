//
//  CategoriesService.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 07.11.2025.
//

import Foundation

protocol ICategoriesService {
    func fetchCategories() async throws -> [Category]
}

final class CategoriesService: ICategoriesService {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }

    func fetchCategories() async throws -> [Category] {
        
        guard let url = URL(string: "http://localhost:3000/categories") else {
            throw NetworkError.invalidURL
        }
        
        let request = URLRequest(url: url)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.statusCode
        }
        
        let categories = try decoder.decode([Category].self, from: data)
        return categories
    }
    
}
