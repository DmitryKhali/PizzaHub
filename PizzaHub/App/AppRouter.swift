//
//  AppRouter.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 22.01.2026.
//

import UIKit

protocol IAppRouter {
    func showDeliveryAddress(sourceVC: UIViewController)
    func showDetailProductScreen(_ product: Product, sourceVC: UIViewController, mode: ProductDetailsMode, onProductUpdated: ((Product) -> Void)?)
    func showStory(stories: [Story], selectedStoryIndex: Int, sourceVC: UIViewController)
}

final class AppRouter: IAppRouter {
    private let di: DIContainer
    
    init(di: DIContainer) {
        self.di = di
    }
    
    func showDeliveryAddress(sourceVC: UIViewController) {
        let vc = di.screenFactory.makeDeliveryAddressScreen()
        sourceVC.present(vc, animated: true)
    }
    
    func showDetailProductScreen(_ product: Product, sourceVC: UIViewController, mode: ProductDetailsMode = .add, onProductUpdated: ((Product) -> Void)? = nil) {
        let vc = di.screenFactory.makeDetailProductScreen(product: product, mode: mode, onProductUpdated: onProductUpdated)
        sourceVC.present(vc, animated: true)
    }
    
    func showStory(stories: [Story], selectedStoryIndex: Int, sourceVC: UIViewController) {
        let vc = di.screenFactory.makeStory()
        vc.setup(with: stories, selectedStoryIndex: selectedStoryIndex)
        sourceVC.present(vc, animated: true)
    }
}
