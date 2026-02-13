//
//  MenuContracts.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 13.02.2026.
//

import Foundation

protocol IMenuViewInput: AnyObject {
    func updateView(with state: MenuViewState)
    func setupProperties(with menuModel: MenuModel)
    func reloadData()
}

protocol IMenuViewOutput {
    func viewDidLoad()
    func loadData()
    func showStory(stories: [Story], selectedStoryIndex: Int)
    func showProductDetails(_ product: Product)
}

protocol IMenuInteractorInput {
    func fetchData()
}

@MainActor
protocol IMenuInteractorOutput: AnyObject {
    func dataFetched(with data: MenuModel)
    func dataFetchFailed(with error: Error)
}

protocol IMenuRouterInput {
    func showProductDetails(_ product: Product)
    func showStory(stories: [Story], selectedStoryIndex: Int)
}
