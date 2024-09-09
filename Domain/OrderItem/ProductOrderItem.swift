//
//  ProductOrderItem.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 08/09/2024.
//

import Foundation

public struct ProductOrderItem: Hashable {
    public let product: Wealth
    public var rolloverOption: RollOverOption = .principal
    public var deposit: Int64
    public var infoParser: ProductInfoParser
    
    public init(wealth: Wealth) {
        product = wealth
        deposit = wealth.startingAmount
        infoParser = ProductInfoParser(from: product)
    }
}

// MARK: - Private Functionality
public extension ProductOrderItem {
    /// Calculates the interest based on the principal, annual interest rate, and the actual number of holding days.
    ///
    /// **Interest Formula:**
    /// Interest = Principal x Annual Interest Rate x (Actual Holding Days / 365)
    ///
    /// - Returns: The calculated interest amount.
    func calculateInterest() -> Double {
        let startingAmount = if deposit == product.startingAmount {
            product.startingAmount
        } else {
            deposit
        }
        
        let principal = Double(startingAmount)
        let annualInterestRate = Double(product.rate)
        let holdingDays = Double(infoParser.quantity ?? 0)
        let daysInYear = Double(365)
        
        return principal * annualInterestRate * (holdingDays / daysInYear)
    }
}
