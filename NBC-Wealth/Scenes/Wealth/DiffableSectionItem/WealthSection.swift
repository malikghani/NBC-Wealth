//
//  WealthSection.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 06/09/2024.
//

import Foundation
import Domain
import NeoBase

/// An enumeration representing different sections in a wealth-related view.
enum WealthSection: Hashable {
    /// Represents a section displaying a tabbed page view for navigating the product list.
    case productNavigation(_ groups: ProductGroups<Wealth>)
    
    /// Represents a section displaying a list of products.
    case productList(_ title: String)
}

// MARK: - SectionStickable Conformance
extension WealthSection: SectionStickable {
    var title: String? {
        switch self {
        case .productList(let productName):
            productName
        default:
            nil
        }
    }

    var shouldStick: Bool {
        switch self {
        case .productNavigation:
            true
        default:
            false
        }
    }
}
