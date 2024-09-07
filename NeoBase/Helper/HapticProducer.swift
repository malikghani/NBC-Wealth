//
//  HapticProducer.swift
//  Base
//
//  Created by Ghani's Mac Mini on 05/09/2024.
//

import UIKit

/// A utility struct for performing haptic feedback types.
public struct HapticProducer {
    
    /// The various types of haptic feedback available.
    public enum FeedbackType: String {
        // Selection Feedback
        case selectionChanged
        
        // Normal Feedback
        case soft, rigid, light, medium, heavy
        
        // Notification Feedback
        case success, warning, error
    }
    
    /// The shared instance of `HapticManager`.
    public static let shared = HapticProducer()
    
    /// Performs the specified haptic feedback type.
    ///
    /// - Parameter type: The type of haptic feedback to perform.
    ///
    /// Use this method to trigger different types of haptic feedback based on the provided `FeedbackType`.
    ///
    /// Example usage:
    /// ```
    /// HapticProducer.shared.perform(feedback: .success)
    /// ```
    public func perform(feedback type: FeedbackType) {
        switch type {
        case .selectionChanged: performSelectionFeedback()
        case .soft:
            performFeedback(style: .soft)
        case .rigid:
            performFeedback(style: .rigid)
        case .light:
            performFeedback(style: .light)
        case .medium:
            performFeedback(style: .medium)
        case .heavy:
            performFeedback(style: .heavy)
        case .success:
            performNotificationFeedback(type: .success)
        case .warning:
            performNotificationFeedback(type: .warning)
        case .error:
            performNotificationFeedback(type: .error)
        }
    }
}

// MARK: - Private Functinoality
private extension HapticProducer {
    /// Performs impact feedback with the specified style.
    ///
    /// - Parameter style: The style of impact feedback to perform.
    func performFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: style)
        impactFeedbackGenerator.prepare()
        impactFeedbackGenerator.impactOccurred()
    }
    
    /// Performs notification feedback with the specified type.
    ///
    /// - Parameter type: The type of notification feedback to perform.
    func performNotificationFeedback(type: UINotificationFeedbackGenerator.FeedbackType) {
        let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
        notificationFeedbackGenerator.prepare()
        notificationFeedbackGenerator.notificationOccurred(type)
    }
    
    /// Performs selection feedback.
    func performSelectionFeedback() {
        let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        selectionFeedbackGenerator.prepare()
        selectionFeedbackGenerator.selectionChanged()
    }
}
