//
//  PaymentSection.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 09/09/2024.
//

import Domain

/// An enumeration representing different sections in the payment flow.
enum PaymentSection: Hashable {
    /// Represents a section that displays a countdown timer.
    case countdown
    
    /// Represents a section for the selected payment method.
    case selectedPaymentMethod

    /// Represents a section listing other available payment methods.
    case otherPaymentMethods(isSelected: Bool)
}

// MARK: - Intenal Functionality
extension PaymentSection {
    var title: String? {
        switch self {
        case .otherPaymentMethods(let isSelected):
            isSelected ? "Metode Pembayaran Lain" : "Pilih Metode Pembayaran"
        default:
            nil
        }
    }
}
