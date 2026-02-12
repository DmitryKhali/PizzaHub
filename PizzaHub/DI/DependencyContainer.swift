//
//  DependencyContainer.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 21.12.2025.
//

import Foundation
import UIKit

protocol DIContainer: AnyObject {
    var storiesService: IStoriesService { get }
    var bannersService: IBannersService { get }
    var categoriesService: ICategoriesService { get }
    var productsService: IProductsService { get }
    var ingredientsService: IIngredientsService { get }
    var addressSuggestionService: IAddressSuggestionService { get }
    var productsArchiver: ICartService { get }
    
    var screenFactory: ScreenFactory { get }
//    var appRouter: IAppRouter { get }
    
    var menuProvider: MenuProvider { get }
}

final class DependencyContainer: DIContainer {
    
    let session: URLSession
    let decoder: JSONDecoder
    
    let storiesService: IStoriesService
    let bannersService: IBannersService
    let categoriesService: ICategoriesService
    let productsService: IProductsService
    let ingredientsService: IIngredientsService
    let addressSuggestionService: IAddressSuggestionService
    let productsArchiver: ICartService
    
//    lazy var appRouter: IAppRouter = {
//        AppRouter(di: self)
//    }()
    lazy var screenFactory: ScreenFactory = {
        ScreenFactory(di: self)
    }()
    
    init() {
        session = URLSession.shared
        decoder = JSONDecoder()
        storiesService = StoriesService(session: session, decoder: decoder)
        bannersService = BannersService(session: session, decoder: decoder)
        categoriesService = CategoriesService(session: session, decoder: decoder)
        productsService = ProductsService(session: session, decoder: decoder)
        ingredientsService = IngredientsService(session: session, decoder: decoder)
        addressSuggestionService = AddressSuggestionService(session: session, decoder: decoder)
        productsArchiver = CartService()
    }
    
    var menuProvider: MenuProvider {
        MenuProvider(storiesService: storiesService, bannersService: bannersService, categoriesService: categoriesService, productsService: productsService, productsArchiver: productsArchiver)
    }
}

final class ScreenFactory {
    var di: DIContainer
    
    init(di: DIContainer) {
        self.di = di
    }

    func makeMenuScreen() -> MenuViewController {
        let router = MenuRouter(di: di)
        let interactor = MenuInteractor(provider: di.menuProvider)
        let presenter = MenuPresenter(interactor: interactor, router: router)
        let view = MenuViewController(presenter: presenter)
        
        presenter.view = view
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
    
    func makeCartScreen() -> CartViewController {
        CartViewController()
    }
    
    func makeFindAddressScreen() -> FindAddressViewController {
        FindAddressViewController(addressSuggestionService: di.addressSuggestionService)
    }
    
    func makeProductDetailsScreen(product: Product) -> ProductDetailsViewController {
        ProductDetailsViewController(product: product)
    }
    
    func makeStory() -> StoriesFullscreenViewController {
        let vc = StoriesFullscreenViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.isModalInPresentation = false
        
        return vc
    }
}
