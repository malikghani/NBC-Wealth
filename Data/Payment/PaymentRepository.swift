//
//  PaymentRepository.swift
//  Data
//
//  Created by Ghani's Mac Mini on 09/09/2024.
//

import Domain

/// A protocol that defines the contract for fetching payment related data.
public protocol PaymentRepository {
    /// Fetches the list of available payment methods.
    ///
    /// - Returns: An array of `PaymentMethod` objects.
    func fetchPaymentMethods() async throws -> PaymentMethods
}

public final class PaymentRepositoryImplementation: PaymentRepository {
    private let remoteDataSource: any PaymentRemoteDataSource
    
    public init(remoteDataSource: any PaymentRemoteDataSource = DefaultPaymentRemoteDataSource()) {
        self.remoteDataSource = remoteDataSource
    }
    
    public func fetchPaymentMethods() async throws -> PaymentMethods {
        try await remoteDataSource.fetchPaymentMethods()
    }
}
