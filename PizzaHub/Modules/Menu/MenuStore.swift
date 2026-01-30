//
//  MenuStore.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 28.01.2026.
//

import Foundation
import Combine

// Описание State в одной структуре
struct MenuState {
    var menuViewState: MenuViewState = .initial
    var stories: [Story] = []
    var banners: [Product] = []
    var categories: [Category] = []
    var products: [Product] = []
}

enum MenuAction {
    // Действия пользователя
    case retryLoadTriggered
    
    // Результаты действий
    case viewDidLoad
    case dataLoaded(MenuModel)
    case loadingFailed
}

@MainActor
final class MenuStore: ObservableObject {
    @Published private(set) var state: MenuState
    private let provider: MenuProvider
    private var cancellables = Set<AnyCancellable>()
    
    init(provider: MenuProvider) {
        self.provider = provider
        self.state = MenuState()
    }
    
    // MARK: - Public
    func send(_ action: MenuAction) {
        reduce(state: &state, action: action)
    }
    
    // MARK: - Private
    private func reduce(state: inout MenuState, action: MenuAction) {
        switch action {
        case .viewDidLoad, .retryLoadTriggered:
            state.menuViewState = .loading
            loadMenuDataEffect()
            
        case .dataLoaded(let menuModel):
            state.stories = menuModel.stories
            state.banners = menuModel.banners
            state.categories = menuModel.categories
            state.products = menuModel.products
            state.menuViewState = .loaded
            
        case .loadingFailed:
            state.menuViewState = .error
            
        }

    }
    
    private func loadMenuDataEffect() {
        Task {
            do {
                let menuModel = try await provider.loadData()
                await MainActor.run {
                    send(.dataLoaded(menuModel))
                }
            }
            catch {
                await MainActor.run {
                    send(.loadingFailed)
                }
            }
        }
    }
}

