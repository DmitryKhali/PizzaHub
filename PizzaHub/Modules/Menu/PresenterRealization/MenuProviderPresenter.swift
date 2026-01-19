//
//  MenuProviderPresenter.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 19.01.2026.
//

import Foundation

final class MenuProviderPresenter {
    private let storiesService: IStoriesService
    private let bannersService: IBannersService
    private let categoriesService: ICategoriesService
    private let productsService: IProductsService
    private let productsArchiver: ICartService
    
    init(
        storiesService: IStoriesService,
        bannersService: IBannersService,
        categoriesService: ICategoriesService,
        productsService: IProductsService,
        productsArchiver: ICartService
    )
    {
        self.storiesService = storiesService
        self.bannersService = bannersService
        self.categoriesService = categoriesService
        self.productsService = productsService
        self.productsArchiver = productsArchiver
    }
}

// MARK: - Public
extension MenuProviderPresenter {
    func loadData(completion: @escaping (Result<MenuModel, Error>) -> () ) {
        let group = DispatchGroup()
        var errors: [Error] = []
        
        var fetchedStories: [Story]?
        var fetchedBanners: [Banner]?
        var fetchedCategories: [Category]?
        var fetchedProducts: [Product]?
        
        group.enter()
        storiesService.fetchStories { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let stories):
                fetchedStories = stories
            case .failure(let error):
                errors.append(error)
            }
            group.leave()
        }
        
        group.enter()
        bannersService.fetchBanners { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let banners):
                fetchedBanners = banners
            case .failure(let error):
                errors.append(error)
            }
            group.leave()
        }
        
        group.enter()
        categoriesService.fetchCategories { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let categories):
                fetchedCategories = categories
            case .failure(let error):
                errors.append(error)
            }
            group.leave()
        }
        
        group.enter()
        productsService.fetchProducts { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let products):
                fetchedProducts = products
            case .failure(let error):
                errors.append(error)
            }
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            
            if let firstError = errors.first {
                completion(.failure(firstError))
                return
            }
            
            guard let stories = fetchedStories,
                  let banners = fetchedBanners,
                  let categories = fetchedCategories,
                  let products = fetchedProducts else {
                completion(.failure(NSError(
                    domain: "MenuProvider",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Не все данные загружены" ]))
                )
                return
            }
            
            let menuModel = MenuModel(stories: stories, banners: banners, categories: categories, products: products)
            
            completion(.success(menuModel))
        }
        
    }
}
