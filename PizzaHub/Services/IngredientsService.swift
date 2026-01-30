//
//  IngredientsService.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 30.11.2025.
//

import Foundation

protocol IIngredientsService {
    func fetchIngredients() async throws -> [Ingredient]
}

final class IngredientsService: IIngredientsService {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }
    
    func fetchIngredients() async throws -> [Ingredient] {
        
        guard let url = URL(string: "http://localhost:3000/ingredients") else {
            throw NetworkError.invalidURL
        }
        
        let request = URLRequest(url: url)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.statusCode
        }
        
        let ingredients = try decoder.decode([Ingredient].self, from: data)
        return ingredients
    }
}
