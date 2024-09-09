//
//  PaymentViewState.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 09/09/2024.
//

import Domain

/// Represents the various states of the Payment Method view.
enum PaymentViewState {
    /// Indicates the view is currently loading data.
    case loading
    
    /// Indicates the payment methods have been successfully received.
    case methodReceived
    
    /// Indicates an error occurred, with an associated message.
    case error(message: String)
}
