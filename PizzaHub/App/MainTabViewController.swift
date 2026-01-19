//
//  MainTabViewController.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 21.12.2025.
//

import UIKit

enum MainTab: Int, CaseIterable { // источник истины для таббара
    case menu
    case cart
    
    private var title: String {
        switch self {
        case .menu, .cart:
            ""
        }
    }
    
    private var systemImageName: String {
        switch self {
        case .menu:
            "house"
        case .cart:
            "cart"
        }
    }
    
    func makeViewController(using di: DIContainer) -> UIViewController {
        let vc: UIViewController
        
        switch self {
        case .menu:
            vc = di.screenFactory.makeMenuScreen()
        case .cart:
            vc = di.screenFactory.makeCartScreen()
        }
        
        vc.tabBarItem = makeTabBarItem()
        return vc
    }
    
    private func makeTabBarItem() -> UITabBarItem {
        UITabBarItem(title: self.title, image: UIImage(systemName: systemImageName), selectedImage: UIImage(systemName: systemImageName))
    }
}

final class MainTabViewController: UITabBarController {
    
    let di: DIContainer
    
    init(di: DIContainer) {
        self.di = di
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupViewControllers()
    }
    
    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .systemBackground
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.green // TODO: не рабэтает зеленый цвет
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.red
        
        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance // TODO: Краевое состояние — когда контент прокручен до самого низа
    }
    
    private func setupViewControllers() {
        self.viewControllers = MainTab.allCases.map { $0.makeViewController(using: di) }
    }
}
