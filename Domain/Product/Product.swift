//
//  Product.swift
//  Networking
//
//  Created by Ghani's Mac Mini on 05/09/2024.
//

import Foundation

/// A protocol that represents a basic product.
public protocol Product: Decodable {
    /// The name of the product.
    var name: String { get }
    
    /// The unique code of the product.
    var code: String { get }
}
