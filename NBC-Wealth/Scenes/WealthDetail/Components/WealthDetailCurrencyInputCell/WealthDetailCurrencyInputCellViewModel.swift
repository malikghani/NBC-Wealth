//
//  WealthDetailCurrencyInputCellViewModel.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 09/09/2024.
//

import Domain

final class WealthDetailCurrencyInputCellViewModel {
    private(set) var orderItem: WealthProductOrderItem
    
    init(orderItem: WealthProductOrderItem) {
        self.orderItem = orderItem
    }
}
