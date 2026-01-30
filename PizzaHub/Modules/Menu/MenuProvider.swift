//
//  MenuProvider.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 18.01.2026.
//

import Foundation
import Combine

struct MenuModel {
    let stories: [Story]
    let banners: [Product]
    let categories: [Category]
    let products: [Product]
}

final class MenuProvider {
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
extension MenuProvider {
    func loadData() async throws -> MenuModel {
        
        async let storiesTask = storiesService.fetchStories()
        async let bannersTask = bannersService.fetchBanners()
        async let categoriesTask = categoriesService.fetchCategories()
        async let productsTask = productsService.fetchProducts()
        
        let (stories, banners, categories, products) = try await (storiesTask, bannersTask, categoriesTask, productsTask)
        
        return MenuModel(stories: stories, banners: banners, categories: categories, products: products)
    }
}
