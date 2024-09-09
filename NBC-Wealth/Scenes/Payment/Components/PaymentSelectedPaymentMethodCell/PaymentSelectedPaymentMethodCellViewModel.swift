//
//  PaymentSelectedPaymentMethodCellViewModel.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 09/09/2024.
//

import Foundation
import Domain

final class PaymentSelectedPaymentMethodCellViewModel {
    private(set) var paymentMethod: PaymentMethod?
    
    init(paymentMethod: PaymentMethod?) {
        self.paymentMethod = paymentMethod
    }
}

// MARK: - Internal Functionality
extension PaymentSelectedPaymentMethodCellViewModel {
    /// Represents the title for current payment method.
    var title: String {
        paymentMethod?.type.title ?? ""
    }
}
