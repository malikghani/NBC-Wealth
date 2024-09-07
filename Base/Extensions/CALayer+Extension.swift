//
//  CALayer+Extension.swift
//  Base
//
//  Created by Ghani's Mac Mini on 07/09/2024.
//

import UIKit

public extension CALayer {
    /// Retrieves all sublayers of the specified type within the current layer's hierarchy.
    ///
    /// - Parameter type: The type of sublayers to retrieve.
    /// - Returns: An array of sublayers of the specified type found within the layer hierarchy.
    func getSublayers<T: CALayer>(type: T.Type) -> [T] {
        var result = sublayers?.compactMap { $0 as? T } ?? []
        for sub in sublayers ?? [] {
            result.append(contentsOf: sub.getSublayers(type: type))
        }
        return result
    }
    
    /// Removes sublayers of the specified type from the current layer's hierarchy.
    ///
    /// - Parameter type: The type of sublayers to remove. If nil, all sublayers are removed.
    func removeSublayers<T: CALayer>(type: T.Type? = nil) {
        if let type = type {
            getSublayers(type: type).forEach { $0.removeFromSuperlayer() }
        } else {
            sublayers?.forEach { $0.removeFromSuperlayer() }
        }
    }
}
