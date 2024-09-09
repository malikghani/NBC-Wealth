//
//  WealthDetailCurrencyInputCellDelegate.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 09/09/2024.
//

import Foundation

/// A delegate protocol for handling user input related to deposit amounts in a wealth detail currency input cell.
protocol WealthDetailCurrencyInputCellDelegate: AnyObject {
    /// Notifies the delegate that the input interaction state has changed.
    ///
    /// - Parameter isInteractable: A boolean value indicating whether the input is interactable (`true`) or non-interactable (`false`).
    func didChangeInputInteraction(to isInteractable: Bool)
    
    /// Called when the user inputs a deposit amount.
    ///
    /// - Parameter amount: The deposit amount entered by the user, represented as an `Int64`.
    func didInputDepositAmount(to amount: Int64)
}
