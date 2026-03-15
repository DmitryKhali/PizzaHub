//
//  MenuInteractor.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 11.02.2026.
//

import Foundation

protocol MenuInteractorInput {
    func fetchData()
}

@MainActor
protocol MenuInteractorOutput: AnyObject {
    func didFetchData(with data: MenuModel)
    func didFailedFetchData(with error: Error)
}

final class MenuInteractor {
    private let provider: MenuProvider
    weak var output: MenuInteractorOutput?
    
    init(provider: MenuProvider) {
        self.provider = provider
    }
}

// MARK: - public
extension MenuInteractor: MenuInteractorInput {
    func fetchData() {
        Task {
            do {
                let menuModel = try await provider.loadData()
//                await MainActor.run {
                    output?.didFetchData(with: menuModel)
//                }
                
            }
            catch {
//                await MainActor.run {
                    output?.didFailedFetchData(with: error)
//                }
            }
        }
    }
}
