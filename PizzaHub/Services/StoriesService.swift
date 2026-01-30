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
    func fetchStories() async throws -> [Story]
}

final class StoriesService: IStoriesService {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }
    
    
    func fetchStories() async throws -> [Story] {
        
        guard let url = URL(string: "http://localhost:3000/stories") else {
            throw NetworkError.invalidURL
        }
        
        let request = URLRequest(url: url)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.statusCode
        }
        
        let stories = try decoder.decode([Story].self, from: data)
        return stories
    }
    
}
