//
//  UIView+Extension.swift
//  Base
//
//  Created by Ghani's Mac Mini on 05/09/2024.
//

import UIKit

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
