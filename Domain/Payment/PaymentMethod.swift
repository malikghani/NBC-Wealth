//
//  PaymentMethod.swift
//  Domain
//
//  Created by Ghani's Mac Mini on 09/09/2024.
//

import Foundation

/// A typealias for an array of payment methods.
public typealias PaymentMethods = [PaymentMethod]

/// Represents a payment method with its type, name, and icon.
public struct PaymentMethod: Decodable, Hashable {
    public let type: PaymentMethodType
    public let name: String
    public let icon: String
}
