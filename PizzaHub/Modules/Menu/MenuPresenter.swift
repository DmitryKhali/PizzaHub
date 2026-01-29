//
//  MenuPresenter.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 28.01.2026.
//

import Foundation

protocol IMenuPresenter {
    var stories: [Story] { get }
    var banners: [Product] { get }
    var categories: [Category] { get }
    var products: [Product] { get }
    var state: MenuViewState { get }
    
    func viewDidLoad()
    func retryLoadData()
}

final class MenuPresenter: IMenuPresenter {
    private let provider: MenuProvider
    weak var viewController: IMenuViewController?
    
    var stories: [Story] = []
    var banners: [Product] = []
    var categories: [Category] = []
    var products: [Product] = []
    
    var state: MenuViewState = .initial {
        didSet {
            viewController?.updateUI(state)
        }
    }
    
    init(provider: MenuProvider) {
        self.provider = provider
    }
}

// MARK: - Private methods
extension MenuPresenter {
    private func loadData() {
        state = .loading
        
        provider.loadData { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let menuModel):
                self.stories = menuModel.stories
                self.banners = menuModel.banners
                self.categories = menuModel.categories
                self.products = menuModel.products
                self.state = .loaded
                self.viewController?.reloadData()
            case .failure(let failure):
                self.state = .error
                print(failure.localizedDescription)
            }
        }
    }
}

// MARK: - Public methods
extension MenuPresenter {
    func viewDidLoad() {
        loadData()
    }
    
    func retryLoadData() {
        loadData()
    }
}
