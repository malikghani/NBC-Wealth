//
//  ViewModelProviding.swift
//  Base
//
//  Created by Ghani's Mac Mini on 05/09/2024.
//

import UIKit

/// A protocol that provides a view model for conforming objects.
///
/// The `ViewModelProviding` protocol defines an associated type `ViewModel` and requires a `viewModel` property of that type.
/// Conforming types must also implement an initializer that accepts a `ViewModel` instance.
public protocol ViewModelProviding {
    /// The type of the view model associated with the conforming object.
    associatedtype ViewModel

    /// The view model associated with the conforming object.
    var viewModel: ViewModel { get set }

    /// Initializes the conforming object with the specified view model.
    ///
    /// - Parameter viewModel: The view model to associate with the object.
    init(viewModel: ViewModel)
}

// MARK: - Default Implementation of ViewModelProviding for UIViewController
public extension ViewModelProviding where Self: UIViewController {
    /// Initializes the view controller with a specified view model.
    ///
    /// - Parameter viewModel: The view model to associate with the view controller.
    init(viewModel: ViewModel) {
        self.init()
        self.viewModel = viewModel
    }
}

// MARK: - Default Implementation of ViewModelProviding for UIView
public extension ViewModelProviding where Self: UIView {
    /// Initializes the view with a specified view model.
    ///
    /// - Parameter viewModel: The view model associated with the view.
    init(viewModel: ViewModel) {
        self.init()
        self.viewModel = viewModel
    }
}

// MARK: - ViewModelProviding & DelegateProviding Extension for Self as UIViewController
public extension ViewModelProviding where Self: UIViewController, Self: DelegateProviding {
    /// Initializes the ViewController with a ViewModel and Delegate.
    ///
    /// - Parameters:
    ///   - viewModel: The ViewModel associated with the ViewController.
    ///   - delegate: The Delegate associated with the ViewController.
    init(viewModel: ViewModel, delegate: Delegate) {
        self.init(viewModel: viewModel)
        self.delegate = delegate
    }
}

// MARK: - ViewModelProviding & DelegateProviding Extension for Self as UIView
public extension ViewModelProviding where Self: UIView, Self: DelegateProviding {
    /// Initializes the View with a ViewModel and Delegate.
    ///
    /// - Parameters:
    ///   - viewModel: The ViewModel associated with the View.
    ///   - delegate: The Delegate associated with the View.
    init(viewModel: ViewModel, delegate: Delegate) {
        self.init()
        self.viewModel = viewModel
        self.delegate = delegate
    }
}
