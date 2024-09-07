//
//  WealthProductNavigationHeaderViewDelegate.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 08/09/2024.
//

import Domain

/// A protocol that delegates actions related to navigating wealth products in a table view.
protocol WealthProductNavigationHeaderViewDelegate: AnyObject {
    /// Called when a product group is tapped.
    ///
    /// - Parameter product: The `Wealth` object representing the selected product.
    func didTapProductGroup(of productGroup: ProductGroup<Wealth>)
}
