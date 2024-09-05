//
//  DelegateProviding.swift
//  Base
//
//  Created by Ghani's Mac Mini on 05/09/2024.
//

import UIKit

/// A protocol represents an object that has a Delegate.
public protocol DelegateProviding {
    associatedtype Delegate
    var delegate: Delegate? { get set }
}

// MARK: - DelegateProviding Extension for Self as UIView
public extension DelegateProviding where Self: UIView {
    /// Initializes the View with a Delegate.
    ///
    /// - Parameters:
    ///   - delegate: The Delegate associated with the ViewController.
    init(delegate: Delegate) {
        self.init()
        self.delegate = delegate
    }
}
