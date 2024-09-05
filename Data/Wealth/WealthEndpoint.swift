//
//  WealthEndpoint.swift
//  Networking
//
//  Created by Ghani's Mac Mini on 05/09/2024.
//

import Networking

/// Defines the various endpoints for the Wealth API.
public enum WealthEndpoint: Endpoint {
    /// Endpoint to retrieve a list of deposits.
    case getList
    
    public var method: HTTPMethod {
        switch self {
        case .getList:
            .GET
        }
    }
    
    public var path: String {
        switch self {
        case .getList:
            "interview/deposits/list"
        }
    }
}
