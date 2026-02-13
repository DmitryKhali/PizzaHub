//
//  MenuPresenter.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 11.02.2026.
//

// интерфейс для view
protocol IMenuViewOutput {
    func viewDidLoad()
    func loadData()
    
    func showStory(stories: [Story], selectedStoryIndex: Int)
    func showProductDetails(_ product: Product)
}

// интерфейс для interactor
@MainActor // автоматически выполняем методы подписчиков в главной очереди
protocol IMenuInteractorOutput: AnyObject {
    func dataFetched(with data: MenuModel)
    func dataFetchFailed(with error: Error)
}

final class MenuPresenter {
    
    private let interactor: IMenuInteractorInput
    private let router: IMenuRouterInput
    weak var view: IMenuViewInput?
    
    init(interactor: IMenuInteractorInput, router: IMenuRouterInput) {
        self.interactor = interactor
        self.router = router
        
    }
}

// MARK: - public IMenuViewOutput
extension MenuPresenter: IMenuViewOutput {
    func viewDidLoad() {
        fetchData()
    }
    
    func loadData() {
        fetchData()
    }
    
    func showStory(stories: [Story], selectedStoryIndex: Int) {
        router.showStory(stories: stories, selectedStoryIndex: selectedStoryIndex)
    }
    
    func showProductDetails(_ product: Product) {
        router.showProductDetails(product)
    }
}

extension MenuPresenter: IMenuInteractorOutput {
    func dataFetched(with data: MenuModel) {
        view?.setupProperties(with: data)
        view?.updateView(with: .loaded)
        view?.reloadData()
    }
    
    func dataFetchFailed(with error: any Error) {
        view?.updateView(with: .error)
        view?.reloadData()
    }
}

// MARK: - private
extension MenuPresenter {
    private func fetchData() {
        view?.updateView(with: .loading)
        interactor.fetchData()
    }
}
