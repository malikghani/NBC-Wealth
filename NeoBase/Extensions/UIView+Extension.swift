//
//  UIView+Extension.swift
//  Base
//
//  Created by Ghani's Mac Mini on 05/09/2024.
//

import UIKit

// MARK: - UView Constraint Extension
public extension UIView {
    /// Initializes the view with a parent view and adds it to the parent's subview hierarchy.
    ///
    /// If the parent view is a `UITableViewCell` or a `UICollectionViewCell` the current view is added to its `contentView`.
    /// Otherwise, the current view is added directly to the parent view.
    ///
    /// - Parameter parent: The parent view to add the current view to.
    /// - Returns: The current view.
    @discardableResult
    func with(parent: UIView) -> Self {
        switch parent {
        case let tableViewCell as UITableViewCell:
            tableViewCell.contentView.addSubview(self)
        case let collectionViewCell as UICollectionViewCell:
            collectionViewCell.contentView.addSubview(self)
        default:
            parent.addSubview(self)
        }
        
        return self
    }
    
    /// Adds a horizontal constraint to the view based on the specified key path, target anchor, priority, and constant.
    ///
    /// - Parameters:
    ///   - path: A key path to the view's `NSLayoutXAxisAnchor`.
    ///   - target: The target `NSLayoutXAxisAnchor` to which the view's anchor is aligned.
    ///   - priority: The priority of the constraint. Defaults to `.required` (the highest priority).
    ///   - constant: The constant offset to apply to the constraint. Defaults to `0`.
    func constraint(
        _ path: KeyPath<UIView, NSLayoutXAxisAnchor>,
        equalTo target: NSLayoutAnchor<NSLayoutXAxisAnchor>,
        priority: UILayoutPriority = .required,
        constant: CGFloat = 0
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = self[keyPath: path].constraint(equalTo: target, constant: constant)
        constraint.priority = priority
        constraint.isActive = true
    }
    
    /// Adds a vertical constraint to the view based on the specified key path, target anchor, and constant.
    ///
    /// - Parameters:
    ///   - path: A key path to the view's `NSLayoutYAxisAnchor`.
    ///   - target: The target `NSLayoutYAxisAnchor` to which the view's anchor is aligned.
    ///   - constant: The constant offset to apply to the constraint. Defaults to `0`.
    func constraint(
        _ path: KeyPath<UIView, NSLayoutYAxisAnchor>,
        equalTo target: NSLayoutAnchor<NSLayoutYAxisAnchor>,
        constant: CGFloat = 0
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        self[keyPath: path].constraint(equalTo: target, constant: constant).isActive = true
    }

    /// Adds a dimension constraint to the view based on the specified key path and constant.
    ///
    /// - Parameters:
    ///   - path: A key path to the view's `NSLayoutDimension`.
    ///   - constant: The constant value to set the dimension to. Defaults to `0`.
    func constraint(
        _ path: KeyPath<UIView, NSLayoutDimension>,
        constant: CGFloat = 0
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        self[keyPath: path].constraint(equalToConstant: constant).isActive = true
    }
    
    /// Fills the view's superview with the specified spacing.
    ///
    /// - Parameter spacing: The spacing to apply on all sides of the view relative to its superview. Defaults to `0`.
    func fillSuperview(spacing: CGFloat = 0) {
        fillSuperview(horizontalSpacing: spacing, verticalSpacing: spacing)
    }

    /// Fills the view's superview with specified horizontal and vertical spacing.
    ///
    /// - Parameters:
    ///   - horizontalSpacing: The spacing to apply to the leading and trailing edges of the view relative to its superview. Defaults to `0`.
    ///   - verticalSpacing: The spacing to apply to the top and bottom edges of the view relative to its superview. Defaults to `0`.
    func fillSuperview(
        horizontalSpacing: CGFloat = 0,
        verticalSpacing: CGFloat = 0
    ) {
        guard let superview = superview else {
            return
        }
        
        constraint(\.leadingAnchor, equalTo: superview.leadingAnchor, constant: horizontalSpacing)
        constraint(\.topAnchor, equalTo: superview.topAnchor, constant: verticalSpacing)
        constraint(\.trailingAnchor, equalTo: superview.trailingAnchor, constant: -horizontalSpacing)
        constraint(\.bottomAnchor, equalTo: superview.bottomAnchor, constant: -verticalSpacing)
    }
}

// MARK: - UView Animation & Transition Extension
public extension UIView {
    /// Perform a transition animation on the UIView.
    ///
    /// - Parameters:
    ///   - transition: A closure containing the animations to be performed during the transition.
    ///   - duration: The duration of the transition animation in seconds. Default is 0.25 seconds.
    ///   - options: A set of animation options specifying how the transition should be performed.
    ///              Default is .transitionCrossDissolve.
    ///   - completion: A closure to be executed after the transition animation has completed.
    func transition(_ transition: (() -> Void)?,
                    duration: TimeInterval = 0.25,
                    options: UIView.AnimationOptions = [.transitionCrossDissolve],
                    completion:  (() -> Void)? = nil) {
        UIView.transition(with: self, duration: duration, options: options) {
            transition?()
        } completion: { _ in
            completion?()
        }
    }
    
    /// Performs a spring animation with customizable parameters.
    ///
    /// - Parameters:
    ///   - duration: The duration of the animation.
    ///   - delay: The delay before the animation starts.
    ///   - damping: The damping ratio for the spring animation.
    ///   - velocity: The initial spring velocity.
    ///   - options: Additional animation options.
    ///   - animation: The closure containing the animation code.
    ///   - completion: The closure to be executed upon completion of the animation.
    func springAnimation(duration: Double = 0.25,
                         delay: Double = 0,
                         damping: Double = 0.75,
                         velocity: Double = 0.9,
                         options: UIView.AnimationOptions = [.curveEaseInOut],
                         animation: @escaping (() -> Void),
                         completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: options, animations: {
            animation()
        }) { _ in
            completion?()
        }
    }
}
