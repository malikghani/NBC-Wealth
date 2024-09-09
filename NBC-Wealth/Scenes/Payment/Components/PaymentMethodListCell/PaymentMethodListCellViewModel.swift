//
//  PaymentMethodListCellViewModel.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 09/09/2024.
//

import Domain

final class PaymentMethodListCellViewModel {
    private(set) var paymentMethods: PaymentMethods
    
    init(paymentMethods: PaymentMethods) {
        self.paymentMethods = paymentMethods
    }
}

// MARK: - Internal Funcitionality
extension PaymentMethodListCellViewModel {
    var title: String {
        paymentMethods.first?.type.title ?? ""
    }
    
    var description: String {
        paymentMethods.first?.type.description ?? ""
    }
}
