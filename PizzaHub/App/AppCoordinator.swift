//
//  AppCoordinator.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 17.01.2026.
//

import UIKit

protocol IAppCoordinator: AnyObject {
    func showProductDetails(_ product: Product, from viewController: UIViewController)
}
//
//final class AppCoordinator: IAppCoordinator {
//
//}
