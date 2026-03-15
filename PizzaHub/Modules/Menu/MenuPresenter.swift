//
//  MenuPresenter.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 11.02.2026.
//

final class MenuPresenter {
    private let interactor: MenuInteractorInput
    private let router: MenuRouterInput
    weak var view: MenuViewInput?
    
    init(interactor: MenuInteractorInput, router: MenuRouterInput) {
        self.interactor = interactor
        self.router = router
        
    }
}

// MARK: - public
extension MenuPresenter: MenuViewOutput {
    func viewDidLoad() {
        fetchData()
    }
    
    func didTapRetry() {
        fetchData()
    }
    
    func didSelectStory(stories: [Story], selectedStoryIndex: Int) {
        router.openStoryScreen(stories: stories, selectedStoryIndex: selectedStoryIndex)
    }
    
    func didSelectProduct(_ product: Product) {
        router.openProductDetailsScreen(product)
    }
}

extension MenuPresenter: MenuInteractorOutput {
    func didFetchData(with data: MenuModel) {
        view?.render(.loaded(data))
    }
    
    func didFailedFetchData(with error: any Error) {
        view?.render(.error)
    }
}

// MARK: - private
extension MenuPresenter {
    private func fetchData() {
        view?.render(.loading)
        interactor.fetchData()
    }
}
