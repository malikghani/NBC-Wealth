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
    /// Fetches product groups from the repository and updates the view state.
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

    /// Retrieves a product group based on the provided title.
    ///
    /// - Parameter title: The title of the product group to find. If `nil`, the method returns `nil`.
    /// - Returns: The `ProductGroup<Wealth>` instance with the matching title, or `nil` if no match is found.
    func getProductGroup(for title: String?) -> ProductGroup<Wealth>? {
        guard let title else {
            return nil
        }
        
        return productGroups.first(where: { $0.name == title })
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
        
        snapshot.appendSections([.productNavigation(productGroups)])
        snapshot.appendItems([.productNavigation], toSection: .productNavigation(productGroups))
        
        for group in productGroups {
            let products = group.products.map {
                WealthItem.product($0, getProductPosition(for: $0, in: group.products))
            }
            
            let productSection = WealthSection.productList(group.name)
            snapshot.appendSections([productSection])
            snapshot.appendItems(products, toSection: productSection)
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
