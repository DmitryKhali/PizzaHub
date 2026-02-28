//
//  DependencyContainer.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 21.12.2025.
//

import UIKit

protocol DIContainer: AnyObject {
    var storiesService: IStoriesService { get }
    var bannersService: IBannersService { get }
    var categoriesService: ICategoriesService { get }
    var productsService: IProductsService { get }
    var ingredientsService: IIngredientsService { get }
    var addressSuggestionService: IAddressSuggestionService { get }
    var cartService: ICartService { get }
    
    var screenFactory: ScreenFactory { get }
    var appRouter: IAppRouter { get }
    
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
    let cartService: ICartService
    
    lazy var appRouter: IAppRouter = {
        AppRouter(di: self)
    }()
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
        cartService = CartService()
        
//        appRouter = AppRouter(di: self)
//        screenFactory = ScreenFactory(di: self)
//        screenFactory.di = self
    }
    
    var menuProvider: MenuProvider {
        MenuProvider(storiesService: storiesService, bannersService: bannersService, categoriesService: categoriesService, productsService: productsService, productsArchiver: cartService)
    }
}

final class ScreenFactory { // TODO: закрывать интерфейсом?
//    weak var di: DIContainer!
    var di: DIContainer // TODO: если обьекты в любом случае должы жить оба, есть ли смысл делать weak?
    
    init(di: DIContainer) {
        self.di = di
    }
    
//    func makeMenuScreen() -> MenuViewController {
//        MenuViewController(
//            storiesService: di.storiesService,
//            bannersService: di.bannersService,
//            categoriesService: di.categoriesService,
//            productsService: di.productsService,
//            productsArchiver: di.productsArchiver
//        )
//    }
    
    // MVC sample
    func makeMenuScreen() -> MenuViewController {
        MenuViewController(provider: di.menuProvider, router: di.appRouter)
    }
    
    func makeCartScreen() -> CartViewController {
        CartViewController(cartService: di.cartService, router: di.appRouter)
    }
    
    func makeDeliveryAddressScreen() -> SavedAddressesViewController {
        let vc = SavedAddressesViewController()
        
        vc.modalPresentationStyle = .overFullScreen
        vc.isModalInPresentation = false
        
        return vc
    }
    
    func makeFindAddressScreen() -> FindAddressViewController {
        FindAddressViewController(addressSuggestionService: di.addressSuggestionService)
    }
    
    func makeDetailProductScreen(product: Product, mode: ProductDetailsMode = .add, onProductUpdated: ((Product) -> Void)? = nil) -> ProductDetailsViewController {
        let vc = ProductDetailsViewController(
            product: product,
            ingredientsService: di.ingredientsService,
            cartService: di.cartService,
            mode: mode
        )
        vc.onProductUpdated = onProductUpdated
        
        return vc
    }
    
    func makeStory() -> StoriesFullscreenViewController {
        let vc = StoriesFullscreenViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.isModalInPresentation = false
        
        return vc
    }
}
