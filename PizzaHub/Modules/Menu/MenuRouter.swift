//
//  MenuRouter.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 12.02.2026.
//

import Foundation
import UIKit

protocol MenuRouterInput {
    func openProductDetailsScreen(_ product: Product)
    func openStoryScreen(stories: [Story], selectedStoryIndex: Int)
}

final class MenuRouter: MenuRouterInput {
    
    private let di: DIContainer
    weak var viewController: MenuViewController?
    
    init(di: DIContainer) {
        self.di = di
    }
    
    func openProductDetailsScreen(_ product: Product) {
        let vc = di.screenFactory.makeProductDetailsScreen(product: product)
        viewController?.present(vc, animated: true)
    }
    
    func openStoryScreen(stories: [Story], selectedStoryIndex: Int) {
        let vc = di.screenFactory.makeStory()
        vc.setup(with: stories, selectedStoryIndex: selectedStoryIndex)
        viewController?.present(vc, animated: true)
    }
}
