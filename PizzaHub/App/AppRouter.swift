//
//  AppRouter.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 22.01.2026.
//

import UIKit

protocol IAppRouter {
    func showProductDetails(_ product: Product, sourceVC: UIViewController)
}

final class AppRouter: IAppRouter {
    
    private let di: DIContainer
    
    init(di: DIContainer) {
        self.di = di
    }
    
    func showProductDetails(_ product: Product, sourceVC: UIViewController) {
        let vc = di.screenFactory.makeProductDetailsScreen(product: product)
        sourceVC.present(vc, animated: true)
    }
    
}
