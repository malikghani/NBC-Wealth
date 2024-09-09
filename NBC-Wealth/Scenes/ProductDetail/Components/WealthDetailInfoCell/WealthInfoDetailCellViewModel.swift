//
//  WealthInfoDetailCellViewModel.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 08/09/2024.
//

import Domain

final class WealthDetailInfoCellViewModel {
    private let orderItem: ProductOrderItem
    
    init(orderItem: ProductOrderItem) {
        self.orderItem = orderItem
    }
}

// MARK: - Internal Functionality
extension WealthDetailInfoCellViewModel {
    /// Provides a description of the product's rate in percentage per annum.
    var rateDescription: String {
        "\(orderItem.product.rate.toPercentage()) p.a."
    }
    
    /// Returns a description of the holding days for the current order item.
    var holdingDaysDescription: String {
        orderItem.infoParser.description
    }
}
