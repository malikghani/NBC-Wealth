//
//  ProductInfoParser.swift
//  Domain
//
//  Created by Ghani's Mac Mini on 09/09/2024.
//

import Foundation

/// A parser to extract the quantity and unit of a product, which represents the holding duration.
///
/// **Note:** Using regex to extract these values is not recommended in practice. It is preferable for the backend to provide these values directly.
public struct ProductInfoParser: Hashable {
    /// The product for which the holding duration is being determined.
    private let product: any Product
        
    /// The quantity of the product holding duration, which can be in days, months, or years (e.g., 1, 3, 6).
    var quantity: Int?
        
    /// The quantity of the product holding duration, normalized to days.
    var normalizedQuantity: Int?
        
    /// The unit of the product holding duration (e.g., "days", "months", "years").
    var unit: String?
    
    /// The description of the Maturity Date.
    public var maturityDateDescription = ""
    
    /// Represent plain description for quantity and unit (e.g., "2 days")
    public var description: String {
        guard let quantity, let unit else {
            return ""
        }
        
        return "\(quantity) \(unit)"
    }
    
    init(from product: any Product) {
        self.product = product
        extractValues()
        normalizeToDays()
        setMaturityDate()
    }
}

// MARK: - Private Functionality
private extension ProductInfoParser {
    mutating func extractValues() {
        let productName = product.name
        let pattern = "\\b(\\d+)\\s+(.*)"
        
        if let regex = try? NSRegularExpression(pattern: pattern),
           let match = regex.firstMatch(in: productName, range: NSRange(productName.startIndex..., in: productName)) {
            
            // Extract the number
            if let numberRange = Range(match.range(at: 1), in: productName) {
                quantity = Int(productName[numberRange])
            }
            
            // Extract the remaining text
            if let textRange = Range(match.range(at: 2), in: productName) {
                unit = String(productName[textRange])
            }
        }
    }
    
    mutating func normalizeToDays() {
        guard let quantity, let unit else {
            return
        }
        
        switch unit {
        case "year", "years":
            normalizedQuantity = quantity * 365
        case "month", "months":
            normalizedQuantity = quantity * 30
        case "day", "days":
            normalizedQuantity = quantity
        default:
            break
        }
    }
    
    mutating func setMaturityDate() {
        guard let normalizedQuantity else {
            return
        }
        
        let calendar = Calendar.current
        let maturityDate = calendar.date(byAdding: .day, value: normalizedQuantity, to: Date())
        
        guard let maturityDate else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "id")
        dateFormatter.dateStyle = .long
        let formattedDate = dateFormatter.string(from: maturityDate)
        
        maturityDateDescription = formattedDate
    }
}

// MARK: - Hashable Conformance
extension ProductInfoParser {
    public static func == (lhs: ProductInfoParser, rhs: ProductInfoParser) -> Bool {
        lhs.product.code == rhs.product.code
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(product.code)
    }
}
