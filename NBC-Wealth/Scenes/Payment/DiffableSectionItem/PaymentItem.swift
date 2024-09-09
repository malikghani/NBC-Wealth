//
//  PaymentItem.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 09/09/2024.
//

import Foundation
import Domain

/// An enumeration representing different items in the payment flow.
enum PaymentItem: Hashable {
    /// Represents a item that displays a countdown timer.
    case countdown(WealthProductOrderItem, Date)
    
    /// Represents the selected payment method.
    ///
    /// - Parameter paymentMethod: The selected payment method.
    case selectedMethod(PaymentMethod?)

    /// Represents a list of other available payment methods.
    ///
    /// - Parameter paymentMethods: A list of other payment methods.
    case methodList(PaymentMethods)
}
