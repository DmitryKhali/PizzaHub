//
//  CategoriesService.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 07.11.2025.
//

import Foundation

protocol ICategoriesService {
    func fetchCategories(completion: @escaping (Result<[Category], Error>) -> ())
}

final class CategoriesService: ICategoriesService {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }

    func fetchCategories(completion: @escaping (Result<[Category], Error>) -> ()) {
        
        guard let url = URL(string: "http://localhost:3000/categories") else {
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
                let categories = try self.decoder.decode([Category].self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(categories))
                }
                
            }
            catch {
                completion(.failure(NetworkError.decode))
            }
        }
        
        task.resume()
    }
    
}
