//
//  WealthViewState.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 06/09/2024.
//

import Foundation

/// Represents the various states of the Wealth view.
enum WealthViewState {
    /// Indicates the view has no data to display.
    case empty
    
    /// Indicates the view is currently loading data.
    case loading
    
    /// Indicates the products have been successfully received.
    case productsReceived
    
    /// Indicates an error occurred, with an associated message.
    case error(message: String)
}

// MARK: - Public Functionality
extension WealthViewState {
    /// Determines whether the loading state view should be toggled based on the current state.
    var shouldShowLoadingIndicator: Bool {
        if case .loading = self {
            return true
        }
        
        return false
    }
}
