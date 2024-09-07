//
//  SectionStickable.swift
//  Base
//
//  Created by Ghani's Mac Mini on 07/09/2024.
//

import Foundation

/// A protocol that defines sections capable of having a sticky header.
public protocol SectionStickable: Hashable {
    /// A Boolean value indicating whether the section's header should stick to the top of the view when scrolling.
    var shouldStick: Bool { get }
}

// MARK: - SectionStickable Default Implementation
public extension SectionStickable {
    /// The default implementation of `shouldStick` returns `false`.
    var shouldStick: Bool {
        false
    }
}
