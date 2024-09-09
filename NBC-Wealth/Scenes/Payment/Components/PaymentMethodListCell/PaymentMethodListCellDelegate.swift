//
//  PaymentMethodListCellDelegate.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 09/09/2024.
//

import Domain

/// A protocol for handling user interactions with payment methods in a list cell.
protocol PaymentMethodListCellDelegate: AnyObject {
    /// Called when a payment method is selected by the user.
    ///
    /// - Parameter paymentMethod: The payment method that was selected.
    func didSelectPaymentMethod(_ paymentMethod: PaymentMethod)
}
