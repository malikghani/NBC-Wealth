//
//  WealthDetailViewState.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 08/09/2024.
//

import Foundation
/// Represents the various states of the WealthDetail view.
enum WealthDetailViewState {
    /// Indicates that the view is currently loading data.
    case loading
    
    /// Indicates that an order has been successfully created.
    case orderCreated
    
    /// Indicates an error occurred, with an associated message.
    /// - Parameter message: A `String` containing the error message.
    case error(message: String)
}

// MARK: - Internal Functionality
extension WealthDetailViewState {
    /// Determines whether the loading state view should be toggled based on the current state.
    var shouldShowLoadingIndicator: Bool {
        if case .loading = self {
            return true
        }
        
        return false
    }
}
