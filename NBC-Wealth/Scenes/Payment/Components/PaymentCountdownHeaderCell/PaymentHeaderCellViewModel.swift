//
//  PaymentCountdownHeaderCellViewModel.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 09/09/2024.
//

import Foundation
import Domain

final class PaymentCountdownHeaderCellViewModel {
    // Dependencies
    private(set) var countdownPublisher = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    private(set) var orderItem: ProductOrderItem
    private(set) var endDate: Date
    
    init(orderItem: ProductOrderItem, endDate: Date) {
        self.orderItem = orderItem
        self.endDate = endDate
    }
}
