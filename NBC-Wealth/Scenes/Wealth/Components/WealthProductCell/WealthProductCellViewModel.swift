//
//  WealthProductCellViewModel.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 06/09/2024.
//

import Domain

enum ProductPosition {
    case first
    case middle
    case last
}

final class WealthProductCellViewModel {
    private(set) var product: Wealth
    private(set) var position: ProductPosition
    
    init(product: Wealth, position: ProductPosition) {
        self.product = product
        self.position = position
    }
}

// MARK: - Internal Functionality
extension WealthProductCellViewModel {
    /// Represents the name of the product.
    var name: String {
        product.name
    }

    /// Represents a description of the product, generated by joining marketing points.
    var description: String? {
        shouldHideMarketingPoints ? nil : product.marketingPoints.joined(separator: ", ")
    }
    
    /// A Boolean value indicating whether marketing points should be hidden.
    var shouldHideMarketingPoints: Bool {
        product.marketingPoints.isEmpty
    }

    /// Provides a description of the product's rate in percentage per annum.
    var rateDescription: String {
        "\(product.rate.toPercentage()) p.a."
    }

    /// Provides a description of the product's starting amount in Indonesian Rupiah.
    var startingAmountDescription: String {
        product.startingAmount.toIDR()
    }
    
    /// Indicates whether the product is marked as popular.
    var shouldShowPopular: Bool {
        product.isPopular
    }
}
