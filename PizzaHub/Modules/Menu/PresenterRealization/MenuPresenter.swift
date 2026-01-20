//
//  MenuPresenter.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 19.01.2026.
//

import Foundation

protocol IMenuPresenter {
    var stories: [Story] { get }
    var banners: [Banner] { get }
    var categories: [Category] { get }
    var products: [Product] { get }
    
    func viewDidLoad()
}

final class MenuPresenter {
    
    weak var viewController: IMenuViewControllerPresenter?
    private let provider: MenuProviderPresenter
    
    var stories: [Story] = []
    var banners: [Banner] = []
    var categories: [Category] = []
    var products: [Product] = []
    
    init(provider: MenuProviderPresenter) {
        self.provider = provider
    }
    
}

// MARK: - public methods
extension MenuPresenter: IMenuPresenter {
    func viewDidLoad() {
        loadData()
    }
}

// MARK: - private methods
extension MenuPresenter {
    func loadData() {
        provider.loadData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.stories = success.stories
                self.banners = success.banners
                self.categories = success.categories
                self.products = success.products
                
                self.viewController?.updateView()
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    private func updateView() {
        viewController?.updateView()
    }
}
