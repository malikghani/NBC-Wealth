//
//  PaymentRemoteDataSource.swift
//  Data
//
//  Created by Ghani's Mac Mini on 09/09/2024.
//

import Foundation
import Domain
import Networking

/// A protocol that defines the contract for fetching payment related data.
public protocol PaymentRemoteDataSource {
    /// Fetches the list of available payment methods.
    ///
    /// - Returns: An array of `PaymentMethod` objects.
    func fetchPaymentMethods() async throws -> PaymentMethods
}

public final class DefaultPaymentRemoteDataSource: PaymentRemoteDataSource {
    public init() { }
    
    public func fetchPaymentMethods() async throws -> PaymentMethods {
        guard let url = Bundle.main.url(forResource: "payment-methods", withExtension: "json") else {
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let decodedData = try JSONDecoder().decode(Response<PaymentMethods>.self, from: data)
                
            return decodedData.data
        } catch {
            return []
        }
    }
}
