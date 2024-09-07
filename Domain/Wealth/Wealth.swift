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
public struct Wealth: Product, Hashable {
    public let name: String
    public let code: String
    public let rate: Int
    public let marketingPoints: [String]
    public let startingAmount: Int64
    public let isPopular: Bool
    
    enum CodingKeys: String, CodingKey {
        case name = "productName"
        case code
        case rate
        case marketingPoints
        case startingAmount
        case isPopular
    }
}
