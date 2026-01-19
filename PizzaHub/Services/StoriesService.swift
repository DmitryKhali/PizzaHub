//
//  StoriesService.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 07.11.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case statusCode
    case noData
    case decode
}

protocol IStoriesService {
    func fetchStories(completion: @escaping (Result<[Story], Error>) -> ())
}

final class StoriesService: IStoriesService {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }
    
    
    func fetchStories(completion: @escaping (Result<[Story], Error>) -> ()) {
        
        guard let url = URL(string: "http://localhost:3000/stories") else {
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
                let stories = try self.decoder.decode([Story].self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(stories))
                }
                
            } catch {
                completion(.failure(NetworkError.decode))
            }
        }
        
        task.resume()
        
    }
    
}
