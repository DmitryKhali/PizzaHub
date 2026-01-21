//
//  MenuProvider.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 18.01.2026.
//

import Foundation

struct MenuModel {
    let stories: [Story]
    let banners: [Banner]
    let categories: [Category]
    let products: [Product]
}

final class MenuProvider {
    private let storiesService: IStoriesService
    private let bannersService: IBannersService
    private let categoriesService: ICategoriesService
    private let productsService: IProductsService
    private let productsArchiver: ICartService
    
    var stories: [Story] = []
    var banners: [Banner] = []
    var categories: [Category] = []
    var products: [Product] = []

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
extension MenuProvider {
    func loadData(completion: @escaping (Result<MenuModel, Error>) -> () ) {
        let group = DispatchGroup()
        var errors: [Error] = []
        
        group.enter()
        storiesService.fetchStories { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let stories):
                self.stories = stories
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
                self.banners = banners
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
                self.categories = categories
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
                self.products = products
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
                        
            let menuModel = MenuModel(stories: stories, banners: banners, categories: categories, products: products)
            
            completion(.success(menuModel))
            
        }
    }
}
