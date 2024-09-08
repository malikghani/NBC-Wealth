//
//  UIViewController+Extension.swift
//  Base
//
//  Created by Ghani's Mac Mini on 05/09/2024.
//

import UIKit

// MARK: - Presentation with ViewModelProviding & DelegateProviding Functionality
public extension UIViewController {
    /// Pushes a view controller of the specified type onto the navigation stack with the provided view model.
    ///
    /// This method initializes the view controller with the specified view model and presents it using navigation mode.
    /// The result is marked as discardable.
    ///
    /// - Parameters:
    ///   - viewController: The type of the view controller to push.
    ///   - viewModel: The view model to associate with the view controller.
    ///   - shouldHideBottomBar:  shouldHideBottomBar: Whether to hide the bottom bar when pushed. Defaults to `false`.
    /// - Returns: The instantiated view controller.
    @discardableResult
    func push<T: BaseViewController<V>, V>(
        _ viewController: T.Type, 
        viewModel: V,
        shouldHideBottomBar: Bool = false
    ) -> T {
        let nextViewController = T(viewModel: viewModel)
        nextViewController.hidesBottomBarWhenPushed = shouldHideBottomBar
        return executePresentation(with: nextViewController, mode: .navigation)
    }

    /// Pushes a view controller of the specified type onto the navigation stack with the provided view model and delegate.
    ///
    /// This method initializes the view controller with the specified view model and delegate, and presents it using navigation mode.
    /// The result is marked as discardable.
    ///
    /// - Parameters:
    ///   - viewControllerType: The type of the view controller to push.
    ///   - viewModel: The view model to associate with the view controller.
    ///   - delegate: The delegate to associate with the view controller.
    ///   - shouldHideBottomBar:  shouldHideBottomBar: Whether to hide the bottom bar when pushed. Defaults to `false`.
    /// - Returns: The instantiated view controller.
    @discardableResult
    func push<T: BaseViewControllerDelegate<V, D>, V, D>(
        _ viewControllerType: T.Type, 
        viewModel: V,
        delegate: D,
        shouldHideBottomBar: Bool = false
    ) -> T {
        let nextViewController = T(viewModel: viewModel, delegate: delegate)
        nextViewController.hidesBottomBarWhenPushed = shouldHideBottomBar
        return executePresentation(with: nextViewController, mode: .navigation)
    }
    
    /// Presents a view controller modally with a specified view model.
    ///
    /// - Parameters:
    ///   - viewController: The type of view controller to present.
    ///   - viewModel: The view model associated with the view controller.
    /// - Returns: The presented view controller.
    @discardableResult
    func present<T: BaseViewController<V>, V>(
        _ viewController: T.Type,
        viewModel: V,
        transitionStyle: UIModalTransitionStyle = .coverVertical,
        presentationStyle: UIModalPresentationStyle = .automatic
    ) -> T {
        let nextViewController = T(viewModel: viewModel)
        return executePresentation(with: nextViewController, mode: .modal(transitionStyle, presentationStyle))
    }

    /// Presents a view controller modally with a specified view model and delegate.
    ///
    /// - Parameters:
    ///   - viewControllerType: The type of view controller to present.
    ///   - viewModel: The view model associated with the view controller.
    ///   - delegate: The delegate associated with the view controller.
    /// - Returns: The presented view controller.
    @discardableResult
    func present<T: BaseViewControllerDelegate<V, D>, V, D>(
        _ viewControllerType: T.Type,
        viewModel: V,
        delegate: D,
        transitionStyle: UIModalTransitionStyle = .coverVertical,
        presentationStyle: UIModalPresentationStyle = .automatic
    ) -> T {
        let nextViewController = T(viewModel: viewModel, delegate: delegate)
        return executePresentation(with: nextViewController, mode: .modal(transitionStyle, presentationStyle))
    }

    /// Enumeration representing the presentation mode of the view controller.
    private enum PresentationMode {
        case modal(UIModalTransitionStyle = .coverVertical, UIModalPresentationStyle = .automatic)
        case navigation
    }

    /// Executes the presentation of the view controller based on the specified mode.
    ///
    /// - Parameters:
    ///   - viewController: The view controller to present or push.
    ///   - mode: The presentation mode (modal or navigation).
    /// - Returns: The presented or pushed view controller.
    private func executePresentation<T: UIViewController>(with viewController: T, mode: PresentationMode) -> T {
        view.endEditing(true)
        
        switch mode {
        case .modal(let transitionStyle, let presentationStyle):
            viewController.modalTransitionStyle = transitionStyle
            viewController.modalPresentationStyle = presentationStyle
            present(viewController, animated: true)
        case .navigation:
            navigationController?.pushViewController(viewController, animated: true)
        }
        
        return viewController
    }
}

// MARK: - Computed Properties
public extension UIViewController {
    /// The total height of the navigation bar and status bar combined.
    var totalNavigationBarHeight: CGFloat {
        let navBarHeight = navigationController?.navigationBar.frame.height ?? 0
        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        return navBarHeight + statusBarHeight
    }
    
}

// MARK: - UIResponder Extension
public extension UIResponder {
    /// Retrieves for the nearest parent view controller in the responder chain.
    ///
    /// If the current responder is a view controller, it returns itself.
    /// Otherwise, it traverses up the responder chain until it finds a view controller or reaches the root responder.
    ///
    /// - Returns: The nearest parent view controller of the responder.
    var parentViewController: UIViewController? {
        next as? UIViewController ?? next?.parentViewController
    }
}
