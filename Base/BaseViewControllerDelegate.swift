//
//  BaseViewControllerDelegate.swift
//  Base
//
//  Created by Ghani's Mac Mini on 05/09/2024.
//

import Foundation

open class BaseViewControllerDelegate<ViewModel, Delegate>: BaseViewController<ViewModel>, DelegateProviding {
    /// The public delegate property for this view controller.
    ///
    /// This computed property provides access to the underlying weak delegate storage.
    /// It casts the `underlyingDelegate` to the expected `Delegate` type.
    public final var delegate: Delegate? {
        get {
            underlyingDelegate as? Delegate
        }
        set { }
    }

    /// Underlying delegate for this View Controller.
    ///
    /// Since a weak property needs to be of a class type (`AnyObject`),
    /// we can't pass a protocol that conforms to `AnyObject` as a generic parameter.
    /// Therefore, we store it in an underlying weak storage.
    ///
    /// - SeeAlso: [**Swift Evolution**](https://forums.swift.org/t/support-for-protocols-as-parameters-for-constrained-generics/10009)
    /// - SeeAlso: [**Stack Overflow**](https://stackoverflow.com/q/62174829)
    private final weak var underlyingDelegate: AnyObject?
    
    required public init(viewModel: ViewModel, delegate: Delegate) {
        super.init(viewModel: viewModel)
        self.underlyingDelegate = delegate as AnyObject
    }
    
    public required init(viewModel: ViewModel) {
        super.init(viewModel: viewModel)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
