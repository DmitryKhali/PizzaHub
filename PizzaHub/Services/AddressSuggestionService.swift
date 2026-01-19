//
//  AddressSuggestionService.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 12.01.2026.
//

import Foundation

protocol IAddressSuggestionService {
    func suggestAddreses(for query: String, completion: @escaping (Result<AddressSuggestionResponse, Error>) -> ())
}

final class AddressSuggestionService: IAddressSuggestionService {
    
    private let apiKey = "80e770ed6bf10284ec48d24c348978acab368113"
    private let baseURL = "https://suggestions.dadata.ru/suggestions/api/4_1/rs"
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession, decoder: JSONDecoder) {
        self.session = session
        self.decoder = decoder
    }
    
    func suggestAddreses(for query: String, completion: @escaping (Result<AddressSuggestionResponse, Error>) -> () ) {
        
        guard let url = URL(string: "\(baseURL)/suggest/address") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Token \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let requestBody: [String: Any] = ["query": query, "count": 20]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.statusCode))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.noData))
                }
                return
            }
            
            do {
                let result = try self.decoder.decode(AddressSuggestionResponse.self, from: data) // TODO: обсудить warning
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.decode))
                }
            }
        }
        
        task.resume()
    }
    
}
