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
public struct ProductGroup<P>: Hashable, Decodable where P: Product {
    public let name: String
    public let products: [P]
    
    enum CodingKeys: String, CodingKey {
        case name = "productGroupName"
        case products = "productList"
    }
}
