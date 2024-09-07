//
//  ColorNamespaces.swift
//  NeoBase
//
//  Created by Ghani's Mac Mini on 07/09/2024.
//

/// A structure representing a color namespace for organizing neocolor enums.
public struct ColorNamespace<C: RawRepresentable> where C.RawValue == String {
    private let type: C.Type? = nil
}

// MARK: - ColorNamespace for all NeoColors
public extension ColorNamespace {
    /// NeoColor Border Namespace
    static var border: ColorNamespace<Border> {
        ColorNamespace<Border>()
    }
}
