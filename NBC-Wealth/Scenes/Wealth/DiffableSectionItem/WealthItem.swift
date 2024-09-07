//
//  WealthItem.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 06/09/2024.
//

import Domain

/// An enumeration representing different types of wealth-related items.
enum WealthItem: Hashable {
    /// Represents an item displaying a tabbed page view for navigating through product lists.
    case productNavigation

    /// Represents a product item with associated wealth and position.
    ///
    /// - Parameters:
    ///   - wealth: A `Wealth` instance representing the specific wealth product.
    ///   - position: A `ProductPosition` indicating the position of the product.
    case product(Wealth, ProductPosition)
}
