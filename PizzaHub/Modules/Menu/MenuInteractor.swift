//
//  MenuInteractor.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 11.02.2026.
//

import Foundation

protocol IMenuInteractor {
    func fetchData()
}

final class MenuInteractor {
    private let provider: MenuProvider
    weak var output: IMenuInteractorOutput?
    
    init(provider: MenuProvider) {
        self.provider = provider
    }
}


// MARK: - public
extension MenuInteractor: IMenuInteractor {
    func fetchData() {
        Task {
            do {
                let menuModel = try await provider.loadData()
//                await MainActor.run {
                    output?.dataFetched(with: menuModel)
//                }
                
            }
            catch {
//                await MainActor.run {
                    output?.dataFetchFailed(with: error)
//                }
            }
        }
    }
}
