//
//  Wealth.swift
//  Networking
//
//  Created by Ghani's Mac Mini on 05/09/2024.
//

import Foundation

/// A typealias for an array of `Wealth` objects.
public typealias Wealths = [Wealth]

/// A structure that represents a product with additional attributes.
public struct Wealth: Product {
    public let name: String
    public let code: String
    let rate: Int
    let marketingPoints: [String]
    let startingAmount: Int64
    let isPopular: Bool
    
    /// Similar to `ProductGroup`, it is preferable to access the product name using `product.name` rather than `product.productName`.
    /// This approach maintains consistency and clarity in the code.
    enum CodingKeys: String, CodingKey {
        case name = "productName"
        case code
        case rate
        case marketingPoints
        case startingAmount
        case isPopular
    }
}
