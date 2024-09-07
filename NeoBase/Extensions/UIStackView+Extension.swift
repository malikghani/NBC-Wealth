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

// MARK: - UIStackView Functionality
public extension UIStackView {
    /// Removes all arranged subviews from the stack view.
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    /// Adds an array of views as arranged subviews to the stack view.
    ///
    /// - Parameter views: An array of `UIView` objects to be added as arranged subviews.
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { view in
            addArrangedSubview(view)
        }
    }
}
