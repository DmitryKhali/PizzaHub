//
//  AddressSuggestionResponse.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 12.01.2026.
//

import Foundation

struct AddressSuggestionResponse: Codable {
    let suggestions: [Suggestion]
}

struct Suggestion: Codable {
    let value: String
}

struct DaDataSuggestion {
    let address: String        // "г Москва, ул Сухонская, д 11"
    let latitude: Double?      // 55.878
    let longitude: Double?     // 37.653
    
    // Есть ли точные координаты?
    var hasCoordinates: Bool {
        latitude != nil && longitude != nil
    }
}
