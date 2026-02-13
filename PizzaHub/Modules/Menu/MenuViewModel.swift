//
//  MenuViewModel.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 13.02.2026.
//

import Foundation
import Combine

final class MenuViewModel {
    @Published var state: MenuViewState = .initial
    @Published var stories: [Story] = []
    @Published var banners: [Product] = []
    @Published var categories: [Category] = []
    @Published var products: [Product] = []
    
    private let provider: MenuProvider
    
    init(provider: MenuProvider) {
        self.provider = provider
    }
}

// MARK: - public
extension MenuViewModel {
    func fetchData() {
        loadData()
    }
}

// MARK: private
extension MenuViewModel {
    private func loadData() {
        state = .loading
        
        Task {
            do {
                let menuModel = try await provider.loadData()
                await MainActor.run {
                    stories = menuModel.stories
                    banners = menuModel.banners
                    categories = menuModel.categories
                    products = menuModel.products
                    
                    state = .loaded
                }
            }
            catch {
                await MainActor.run {
                    state = .error
                }
            }
        }
    }
}
