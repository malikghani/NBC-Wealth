//
//  PaymentSelectedPaymentMethodCellDelegate.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 09/09/2024.
//

import Foundation

/// A delegate protocol for handling user interactions in the payment method selection cell.
protocol PaymentSelectedPaymentMethodCellDelegate: AnyObject {
    /// Called when the user taps the "Pay" button.
    func didTapPay()
}
