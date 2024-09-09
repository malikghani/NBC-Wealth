//
//  WealthViewState.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 06/09/2024.
//

import Foundation

/// Represents the various states of the Wealth view.
enum WealthViewState {
    /// Indicates the view is currently loading data.
    case loading
    
    /// Indicates the products have been successfully received.
    case productsReceived
    
    /// Indicates an error occurred, with an associated message.
    case error(message: String)
}
