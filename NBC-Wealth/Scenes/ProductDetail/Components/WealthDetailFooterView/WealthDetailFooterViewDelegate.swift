//
//  WealthDetailFooterViewDelegate.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 08/09/2024.
//

import Foundation

/// A delegate protocol for handling user interactions in the footer view of the wealth detail screen.
protocol WealthDetailFooterViewDelegate: AnyObject {
    /// Called when the action button in the footer view is tapped.
    func didTapActionButton()
    
    /// Called when the user taps on the terms and conditions link.
    func didTapTermsAndConditions()
}
