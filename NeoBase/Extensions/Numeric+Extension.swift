//
//  Numeric+Extension.swift
//  Base
//
//  Created by Ghani's Mac Mini on 07/09/2024.
//

import Foundation

// MARK: - Numeric Extension
public extension Numeric {
    /// Converts the numeric value to an `NSNumber`.
    ///
    /// - Returns: An `NSNumber` representing the numeric value, or nil if the conversion is not supported.
    var nsNumberValue: NSNumber? {
        switch self {
        case let intValue as Int:
            .init(value: intValue)
        case let int8Value as Int8:
            .init(value: int8Value)
        case let int16Value as Int16:
            .init(value: int16Value)
        case let int32Value as Int32:
            .init(value: int32Value)
        case let int64Value as Int64:
            .init(value: int64Value)
        case let doubleValue as Double:
            .init(value: doubleValue)
        case let floatValue as Float:
            .init(value: floatValue)
        case let cgFloatValue as CGFloat:
            .init(value: cgFloatValue)
        default:
            nil
        }
    }
    
    /// Convert any Numeric to an Indonesian Rupiah (IDR) format.
    ///
    /// - Parameter default: The default string to return if the conversion fails. Default is "Rp0".
    /// - Returns: The string in IDR format or the default value if the conversion fails.
    func toIDR(default: String = "Rp0", usingSymbol: Bool = true) -> String {
        guard let nsNumberValue else {
            return `default`
        }
        
        return NumberFormatter.idr(usingSymbol: usingSymbol).string(from: nsNumberValue) ?? `default`
    }
    
    /// Convert any Numeric to percentage format.
    ///
    /// - Parameter default: The default string to return if the conversion fails. Default is "0%".
    /// - Returns: The string in percentage format or the default value if the conversion fails.
    func toPercentage(default: String = "0%") -> String {
        guard let nsNumberValue else {
            return `default`
        }
        
        return NumberFormatter.percentage().string(from: nsNumberValue) ?? `default`
    }
}
