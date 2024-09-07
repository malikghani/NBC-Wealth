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
            let currentProduct = WealthSection.productList(group.name)
            snapshot.appendSections([currentProduct])
            
            let products: [WealthItem] = group.products.map {
                .product($0, getProductPosition(for: $0, in: group.products))
            }
            snapshot.appendItems(products, toSection: currentProduct)
        }
        
        return snapshot
    }
    
    private func getProductPosition<P: Product>(for product: P, in products: [P]) -> ProductPosition {
        if products.first == product {
            .first
        } else if products.last == product {
            .last
        } else {
            .middle
        }
    }
}
