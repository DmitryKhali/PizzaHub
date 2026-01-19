//
//  AddressSuggestionResponse.swift
//  SampleApp
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
