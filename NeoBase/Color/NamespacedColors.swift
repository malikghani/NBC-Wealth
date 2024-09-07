//
//  NamespacedColors.swift
//  NeoBase
//
//  Created by Ghani's Mac Mini on 07/09/2024.
//

/// A protocol that represents a namespaced color with a `String` raw value.
public protocol NamespacedColor: RawRepresentable where RawValue == String {
    /// The namespace for the color.
    static var namespace: String { get }
}

// MARK: - NamespacedColor Default Implementation
public extension NamespacedColor {
    /// Default implementation returns the name of the conforming type as the namespace.
    static var namespace: String {
        String(describing: self).lowercased()
    }
}
