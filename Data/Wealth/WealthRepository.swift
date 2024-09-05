//
//  WealthRepository.swift
//  Networking
//
//  Created by Ghani's Mac Mini on 04/09/2024.
//

import Domain

/// A protocol that defines the contract for fetching wealth-related product groups.
public protocol WealthRepository {
    /// Asynchronously fetches product groups of wealth products.
    ///
    /// - Returns: An array of `ProductGroup` objects containing `Wealth` products.
    func fetchWealthGroups() async throws -> ProductGroups<Wealth>
}

public final class WealthRepositoryImplementation: WealthRepository {
    private let remoteDataSource: any WealthRemoteDataSource
    
    public init(remoteDataSource: any WealthRemoteDataSource = DefaultWealthRemoteDataSource()) {
        self.remoteDataSource = remoteDataSource
    }
    
    public func fetchWealthGroups() async throws -> ProductGroups<Wealth> {
        try await remoteDataSource.fetchWealthGroups()
    }
}
