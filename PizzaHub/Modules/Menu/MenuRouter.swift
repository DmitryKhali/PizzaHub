//
//  MenuRouter.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 12.02.2026.
//

import Foundation
import UIKit



final class MenuRouter: IMenuRouterInput {
    
    private let di: DIContainer
    weak var viewController: MenuViewController?
    
    init(di: DIContainer) {
        self.di = di
    }
    
    func showProductDetails(_ product: Product) {
        let vc = di.screenFactory.makeProductDetailsScreen(product: product)
        viewController?.present(vc, animated: true)
    }
    
    func showStory(stories: [Story], selectedStoryIndex: Int) {
        let vc = di.screenFactory.makeStory()
        vc.setup(with: stories, selectedStoryIndex: selectedStoryIndex)
        viewController?.present(vc, animated: true)
    }
}
