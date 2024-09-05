//
//  WealthRemoteDatasource.swift
//  Networking
//
//  Created by Ghani's Mac Mini on 04/09/2024.
//

import Domain
import Networking

/// A protocol that defines the contract for fetching wealth-related product groups.
public protocol WealthRemoteDataSource {
    /// Asynchronously fetches product groups of wealth products.
    ///
    /// - Returns: An array of `ProductGroup` objects containing `Wealth` products.
    func fetchWealthGroups() async throws -> ProductGroups<Wealth>
}

public final class DefaultWealthRemoteDataSource: WealthRemoteDataSource {
    public init() { }
    
    public func fetchWealthGroups() async throws -> ProductGroups<Wealth> {
        try await APIService<WealthEndpoint>().execute(.getList, to: ProductGroups<Wealth>.self)
    }
}
