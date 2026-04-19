//
//  NetworkClient.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 04.04.2026.
//

import Foundation

protocol INetworkClient {
    func sendRequest(endpoint: IEndpoint, completion: @escaping (Result<Data, any Error>) -> Void)
}

struct NetworkClient: INetworkClient {
    private let session: URLSession = .shared
    
    func sendRequest(endpoint: IEndpoint, completion: @escaping (Result<Data, any Error>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.port = endpoint.port
        
        guard let url = urlComponents.url else {
            completion(.failure(RequestError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        request.allHTTPHeaderFields = endpoint.headers
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if !(200...299).contains(response.statusCode) {
                    completion(.failure(RequestError.statusCode))
                    return
                }
            }
            
            guard let data = data else {
                completion(.failure(RequestError.noData))
                return
            }
            completion(.success(data))
        }
        
        task.resume()
    }
}

//protocol INetworkClient {
//    func fetch(url: URL) async throws -> Data
//}
//
//class NetworkClient: INetworkClient {
//    
//    let session: URLSession
//    
//    init(session: URLSession = .shared) {
//        self.session = session
//    }
//    
//    func fetch(url: URL) async throws -> Data {
//        let reuqest = URLRequest(url: url)
//        
//        let (data, response) = try await session.data(for: reuqest)
//        
//        guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
//            throw NetworkError.statusCode
//        }
//        
//        return data
//    }
//}

///
/// Реализация через cpompletions
///


