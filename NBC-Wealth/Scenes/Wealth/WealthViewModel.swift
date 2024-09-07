//
//  WealthViewModel.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 05/09/2024.
//

import Data
import Domain
import Networking

import Combine
import UIKit

final class WealthViewModel {
    // Subjects
    private(set) var viewState = CurrentValueSubject<WealthViewState, Never>(.loading)
    
    // Dependencies
    private var productGroups: ProductGroups<Wealth> = []
    
    // Repositories
    private let wealthRepository: any WealthRepository
    
    init(wealthRepository: any WealthRepository = WealthRepositoryImplementation()) {
        self.wealthRepository = wealthRepository
    }
}

// MARK: - Public Functionality
extension WealthViewModel {
    func fetchProducts() {
        Task {
            do {
                viewState.send(.loading)
                productGroups = try await wealthRepository.fetchWealthGroups()
                viewState.send(.productsReceived)
            } catch {
                viewState.send(.error(message: error.localizedDescription))
            }
        }
    }
}

// MARK: - Private Functionality
private extension WealthViewModel {
   
}

// MARK: - Snapshot Functionality
extension WealthViewModel {
    typealias Snapshot = NSDiffableDataSourceSnapshot<WealthSection, WealthItem>
    
    /// Builds a snapshot for displaying edit profile data.
    ///
    ///  - Returns: A 'Snapshot' containing the sections and items to be displayed.
    func buildSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        
        for group in productGroups {
            snapshot.appendSections([.productList(group.name)])
            
            for product in group.products {
                let position = if group.products.first == product {
                    ProductPosition.first
                } else if group.products.last == product {
                    ProductPosition.last
                } else {
                    ProductPosition.middle
                }
                
                snapshot.appendItems([.product(product, position)], toSection: .productList(group.name))
            }
        }
        
        return snapshot
    }
}
