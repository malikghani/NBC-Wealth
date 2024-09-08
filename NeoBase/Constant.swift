//
//  Constant.swift
//  NeoBase
//
//  Created by Ghani's Mac Mini on 08/09/2024.
//

import Foundation

/// A collection of static constants used throughout the application.
public enum Constant {
    /// The URL for the privacy policy page.
    public static let privacyPolicuURL = "https://www.bankneocommerce.co.id/id/policy"
    
    /// Predefined deposit amounts for user selection, organized into two categories:
    /// the first array contains [1_000_000, 50_000_000, 100_000_000], and the second array contains [500_000_000].
    public static let preselectAmount: [[Int64]] = [[1_000_000, 50_000_000, 100_000_000], [500_000_000]]
}
