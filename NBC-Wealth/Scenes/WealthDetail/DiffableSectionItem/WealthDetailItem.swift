//
//  WealthDetailItem.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 08/09/2024.
//

import UIKit
import Domain
import NeoBase

/// An enumeration representing different types of items in the wealth detail view.
enum WealthDetailItem: Hashable {
    /// Represents detailed information about a wealth product.
    case info(WealthProductOrderItem)
    
    /// Represents an input field for a deposit related to a wealth product.
    case inputDeposit(WealthProductOrderItem)
    
    /// Represents a estimated interest of a wealth product.
    case estimatedInterest(String)
    
    /// Represents the maturity date of a wealth product.
    case maturityDate(String)
    
    /// Represents options related to rolling over a wealth product.
    case rolloverOption(String)
    
    /// Represents information about coupons related to the wealth product.
    case coupon(String)
    
    /// Represents about coins associated with the wealth product.
    case coins(String)
}

// MARK: - Internal Functionality
extension WealthDetailItem {
    /// Represent the title for each cases.
    var title: String? {
        switch self {
        case .maturityDate:
            "Jatuh Tempo"
        case .estimatedInterest:
            "Estimasi Bunga"
        case .rolloverOption:
            "Opsi Rollover"
        case .coupon:
            "Kupon"
        case .coins:
            "Neo Coins"
        default:
            nil
        }
    }
    
    /// Determines whether a chevron should be shown for the current case.
    var shouldShowChevron: Bool {
        switch self {
        case .rolloverOption, .coupon:
            true
        default:
            false
        }
    }
    
    /// Determines the text scale to be applied for each case.
    var typeScale: NeoLabel.Scale {
        switch self {
        case .estimatedInterest:
            .ternary
        default:
            .subtitle
        }
    }
    
    /// Determines whether the divider should be hidden for the current case.
    var shouldHideDivider: Bool {
        switch self {
        case .estimatedInterest, .coins:
            true
        default:
            false
        }
    }
    
    /// Determines the style of the divider for the current case.
    var dividerStyle: NeoDivider.Style {
        if case .maturityDate = self {
            return .dashed(.init())
        }
        
        return .solid
    }
    
    /// Retrieves the icon associated with the current case, if any.
    var icon: UIImage? {
        if case .coins = self {
            return .init(named: "coin")
        }
        
        return nil
    }
}
