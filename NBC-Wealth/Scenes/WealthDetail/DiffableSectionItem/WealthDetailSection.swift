//
//  WealthDetailSection.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 08/09/2024.
//

import Domain

/// An enumeration representing different sections in the wealth detail view.
enum WealthDetailSection: Hashable {
    /// Represents the section displaying information about the wealth product.
    case info(Wealth)
    
    /// Represents the section for inputting deposit-related information.
    case deposit
    
    /// Represents the section for various rollover options associated with the wealth product.
    case miscellaneous
}

// MARK: - Internal Functionality
extension WealthDetailSection {
    /// Returns the title based on the current case of the enum.
    var title: String? {
        switch self {
        case .info(let product):
            product.name
        case .deposit:
            "Masukan jumlah deposito"
        default:
            nil
        }
    }
}
