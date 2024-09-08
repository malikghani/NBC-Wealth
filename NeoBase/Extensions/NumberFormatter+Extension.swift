//
//  NumberFormatter+Extension.swift
//  Base
//
//  Created by Ghani's Mac Mini on 07/09/2024.
//

import Foundation

public extension NumberFormatter {
    /// Creates a `NumberFormatter` configured for Indonesian Rupiah (IDR) currency display.
    ///
    /// - Returns: A `NumberFormatter` instance tailored for IDR currency display.
    /// - Example:
    ///   ```swift
    ///   let amount = 50000
    ///   let formattedAmount = NumberFormatter.idr().string(from: NSNumber(value: amount))
    ///   print(formattedAmount) // Output: "Rp 50.000"
    ///   ```
    static func idr(usingSymbol: Bool = true) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.currencyCode = "IDR"
        formatter.currencySymbol = usingSymbol ? "Rp" : ""
        formatter.currencyGroupingSeparator = "."
        formatter.currencyDecimalSeparator = ","
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        formatter.locale = Locale(identifier: "id_ID")
        
        return formatter
    }
    
    /// Creates a `NumberFormatter` configured for percentage display.
    ///
    /// - Returns: A `NumberFormatter` instance tailored for percentage display.
    /// - Example:
    ///   ```swift
    ///   let percentageValue = 0.7543
    ///   let formattedPercentage = NumberFormatter.percentage().string(from: NSNumber(value: percentageValue))
    ///   print(formattedPercentage) // Output: "0.75%"
    ///   ```
    static func percentage() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.positiveSuffix = "%"
        
        return formatter
    }
}
