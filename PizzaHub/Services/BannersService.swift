//
//  BannersService.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 07.11.2025.
//

import Foundation

protocol IBannersService {
    func fetchBanners(completion: @escaping (Result<[Product], Error>) -> ())
}

final class BannersService: IBannersService {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }
    
    func fetchBanners(completion: @escaping (Result<[Product], Error>) -> ()) {
        
        guard let url = URL(string: "http://localhost:3000/banners") else {
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
                let banners = try self.decoder.decode([Product].self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(banners))
                }
                
            }
            catch {
                completion(.failure(NetworkError.decode))
            }
            
        }
        
        task.resume()
        
    }
}
