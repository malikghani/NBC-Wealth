//
//  PaymentCountdownHeaderCellViewModel.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 09/09/2024.
//

import Foundation
import Domain

final class PaymentCountdownHeaderCellViewModel {
    private(set) var countdownPublisher = Timer.publish(every: 1.0, on: .main, in: .default).autoconnect()
    
    private(set) var orderItem: WealthProductOrderItem
    private(set) var endDate: Date
    
    init(orderItem: WealthProductOrderItem, endDate: Date) {
        self.orderItem = orderItem
        self.endDate = endDate
    }
}
