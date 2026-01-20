//
//  MainScreenViewModel.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 19.01.2026.
//

import Foundation
import Combine

final class MainScreenViewModel {
    // MARK: Public Properties
    @Published var stories: [Story] = []
    @Published var banners: [Banner] = []
    @Published var categories: [Category] = []
    @Published var products: [Product] = []
    
    // MARK: Private Properties
    private let provider: MenuProvider
    private var cancellables = Set<AnyCancellable>()
    
    init(provider: MenuProvider) {
        self.provider = provider
    }
}

// MARK: Public methods
extension MainScreenViewModel {
    func viewDidLoad() {
        loadData()
    }
}

extension MainScreenViewModel {
    private func loadData() {
        
        provider.loadData { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let success):
                self.stories = success.stories
                self.banners = success.banners
                self.categories = success.categories
                self.products = success.products
            case .failure(let failure):
                print("Error: \(failure.localizedDescription)")
            }
            
        }
        
    }
}
