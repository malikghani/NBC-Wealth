//
//  UIStackView+Extension.swift
//  Base
//
//  Created by Ghani's Mac Mini on 07/09/2024.
//

import UIKit

// MARK: - Initializers Functionality
public extension UIStackView {
    /// Creates a stack view with the provided arranged subviews.
    ///
    /// - Parameter arrangedSubviews: The subviews arranged in the stack view.
    convenience init(of arrangedSubviews: UIView...) {
        self.init(arrangedSubviews: Array(arrangedSubviews))
    }
    
    /// Creates a stack view with the provided arranged subviews.
    ///
    /// - Parameter arrangedSubviews: The subviews arranged in the stack view.
    convenience init(of arrangedSubviews: [UIView]) {
        self.init(arrangedSubviews: arrangedSubviews)
    }
}
