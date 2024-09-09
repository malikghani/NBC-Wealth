//
//  UIView+TapGestureExtension.swift
//  NeoBase
//
//  Created by Ghani's Mac Mini on 09/09/2024.
//

import UIKit

/// Key for associating the tap gesture recognizer with the UIView using objc_setAssociatedObject.
private var tapGestureRecognizerKey: UInt8 = 0

/// Key for associating the tap gesture action closure with the UIView using objc_setAssociatedObject.
private var tapGestureActionKey: UInt8 = 0

// MARK: - Private Functionality
private extension UIView {
    /// Computed property to get/set the tap gesture recognizer using associated objects.
    var tapGestureRecognizer: UITapGestureRecognizer? {
        get {
            objc_getAssociatedObject(self, &tapGestureRecognizerKey) as? UITapGestureRecognizer
        }
        set {
            objc_setAssociatedObject(self, &tapGestureRecognizerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Computed property to get/set the tap gesture action using associated objects.
    var tapGestureAction: (() -> Void)? {
        get {
            objc_getAssociatedObject(self, &tapGestureActionKey) as? (() -> Void)
        }
        set {
            objc_setAssociatedObject(self, &tapGestureActionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Clears the current tap gesture recognizer and associated action closure.
    ///
    /// This method removes the existing tap gesture recognizer and sets the action closure to nil.
    func clearCurrentTapGesture() {
        if let currentTapGestureRecognizer = tapGestureRecognizer {
            removeGestureRecognizer(currentTapGestureRecognizer)
        }
        
        tapGestureAction = nil
    }
    
    /// Handles the tap gesture on the view by executing the associated action closure.
    ///
    /// This method is called when the tap gesture recognizer recognizes a tap on the view.
    @objc private func handleViewTap() {
        tapGestureAction?()
    }
}

// MARK: - Public Functionality
public extension UIView {
    /// Adds a tap gesture recognizer to the view with a specified closure as the action.
    ///
    /// - Parameter onTapAction: The closure to be executed when the view is tapped.
    ///
    /// This method clears the existing tap gesture and associates a new tap gesture recognizer with the specified closure as the action.
    func addTapGesture(onTapAction closure: @escaping () -> Void) {
        clearCurrentTapGesture()
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleViewTap))
        tapGestureAction = closure
        
        if let tapGestureRecognizer {
            addGestureRecognizer(tapGestureRecognizer)
        }
        
        isUserInteractionEnabled = true
    }
    
    /// Adds a tap gesture recognizer to the view.
    ///
    /// - Parameters:
    ///     - tapNumber: The number of taps required for the gesture (default is 1).
    ///     - target: The target object that will handle the tap gesture.
    ///     - action: The selector that specifies the action to perform when the gesture is recognized.
    func addTapGesture(tapNumber: Int = 1, target: Any, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
}
