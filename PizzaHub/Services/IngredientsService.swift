//
//  IngredientsService.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 30.11.2025.
//

import Foundation

protocol IIngredientsService {
    func fetchIngredients(completion: @escaping (Result<[Ingredient], Error>) -> ())
}

final class IngredientsService: IIngredientsService {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }
    
    func fetchIngredients(completion: @escaping (Result<[Ingredient], any Error>) -> ()) {
        
        guard let url = URL(string: "http://localhost:3000/ingredients") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(NetworkError.statusCode))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let ingredients = try self.decoder.decode([Ingredient].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(ingredients))
                }
            }
            catch {
                print(error.localizedDescription)
                completion(.failure(NetworkError.decode))
            }
        }
        
        task.resume()
    }
}
