//
//  MenuViewModel.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 28.01.2026.
//

import Foundation
import Combine

final class MenuViewModel {
    // Properties
    private let provider: MenuProvider
    @Published var state: MenuViewState = .initial
    @Published var stories: [Story] = []
    @Published var banners: [Product] = []
    @Published var categories: [Category] = []
    @Published var products: [Product] = []
    
    // Init
    init(provider: MenuProvider) {
        self.provider = provider
    }
    
}

// MARK: - Public methods

extension MenuViewModel {
    
    func viewDidLoad() {
        loadData()
    }
    
    func retryLoadData() {
        loadData()
    }
    
}

// MARK: - Private methods

extension MenuViewModel {
    
    private func loadData() {
        state = .loading
        provider.loadData { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let menuModel):
                stories = menuModel.stories
                banners = menuModel.banners
                categories = menuModel.categories
                products = menuModel.products
                self.state = .loaded
            case .failure(let failure):
                print(failure.localizedDescription)
                self.state = .error
            }
        }
    }
    
}
