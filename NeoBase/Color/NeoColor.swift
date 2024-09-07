//
//  NeoColor.swift
//  NeoBase
//
//  Created by Ghani's Mac Mini on 07/09/2024.
//

import UIKit

/// A structure representing a color with an associated namespace.
///
/// - Parameter C: A type that conforms to `NamespacedColor`, representing the color enum.
public struct NeoColor<C: NamespacedColor> {
    /// The namespace associated with the color.
    private let nameSpace: ColorNamespace<C>
    
    /// The specific color within the namespace.
    private let color: C
    
    init(nameSpace: ColorNamespace<C>, color: C) {
        self.nameSpace = nameSpace
        self.color = color
    }
}

// MARK: - Public Functionality
public extension NeoColor {
    /// Creates a new `NeoColor` instance with the specified namespace and color.
    ///
    /// - Parameters:
    ///   - namespace: The `ColorNamespace` that specifies the namespace for the color.
    ///   - color: The `NamespacedColor` enum value representing the specific color.
    /// - Returns: A new `NeoColor` instance initialized with the provided namespace and color.
    static func neo(_ namespace: ColorNamespace<C>, color: C) -> NeoColor {
        .init(nameSpace: namespace, color: color)
    }
    
    /// Retrieves the `UIColor` instance corresponding to the color and namespace.
    ///
    /// - Note: If the color cannot be found, it returns `.black` as a fallback.
    /// - Returns: A `UIColor` instance based on the `nameSpace` and `color` properties.
    var value: UIColor {
        .init(named: "\(C.namespace)/\(color.rawValue)") ?? .black
    }
}

// MARK: - UIColor Extension
public extension UIColor {
    /// Creates a `UIColor` object based on a namespaced neo color.
    ///
    /// - Parameters:
    ///   - namespace: A `ColorNamespace` object that specifies the color namespace.
    ///   - color: A `NamespacedColor` object representing the color to be used.
    /// - Returns: A `UIColor` instance corresponding to the specified namespace and color.
    static func neo<C: NamespacedColor>(_ namespace: ColorNamespace<C>, color: C) -> UIColor {
        NeoColor(nameSpace: namespace, color: color).value
    }
}

// MARK: - UIColor Extension
public extension CGColor {
    /// Creates a `CGColor` object based on a namespaced neo color.
    ///
    /// - Parameters:
    ///   - namespace: A `ColorNamespace` object that specifies the color namespace.
    ///   - color: A `NamespacedColor` object representing the color to be used.
    /// - Returns: A `CGColor` instance corresponding to the specified namespace and color.
    static func neo<C: NamespacedColor>(_ namespace: ColorNamespace<C>, color: C) -> CGColor {
        UIColor.neo(namespace, color: color).cgColor
    }
}
