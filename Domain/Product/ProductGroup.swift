//
//  ProductGroups.swift
//  Networking
//
//  Created by Ghani's Mac Mini on 05/09/2024.
//

import Foundation

/// A typealias for an array of `ProductGroup` instances.
public typealias ProductGroups<P: Product> = [ProductGroup<P>]

/// A structure that represents a group of products.
public struct ProductGroup<P>: Decodable where P: Product {
    let name: String
    let products: [P]
    
    /// Coding keys are set to make property names more intuitive.
    /// In my opinition, using `group.name` and `group.products` is clearer than `group.productGroupName` and `group.productList`.
    enum CodingKeys: String, CodingKey {
        case name = "productGroupName"
        case products = "productList"
    }
}
