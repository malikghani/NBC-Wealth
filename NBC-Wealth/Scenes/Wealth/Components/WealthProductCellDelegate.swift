//
//  WealthProductCellDelegate.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 06/09/2024.
//

import Domain

/// Delegate protocol for handling actions in a wealth product cell.
protocol WealthProductCellDelegate: AnyObject {
    /// Called when the call-to-action button of a product is tapped.
    ///
    /// - Parameter product: The wealth product that was interacted with.
    func didTapProductCallToAction(of product: Wealth)
}
