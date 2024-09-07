//
//  WealthSection.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 06/09/2024.
//

import Foundation
import Base

enum WealthSection: Hashable {
    case productList(String)
}

// MARK: - Public Functionality
extension WealthSection: SectionStickable {
    var title: String? {
        switch self {
        case .productList(let productName):
            productName
        }
    }

    var shouldStick: Bool {
        switch self {
        case .productList:
            true
        }
    }
}
