//
//  Endpoint.swift
//  Networking
//
//  Created by Ghani's Mac Mini on 05/09/2024.
//

import Foundation

/// Defines the requirements for an endpoint in a network request.
public protocol Endpoint {
    /// The base URL for the network request.
    var baseURL: String { get }
    
    /// The path for the network request.
    var path: String { get }
    
    /// The HTTP method to use for the request.
    var method: HTTPMethod { get }
    
    /// The parameters to include in the request.
    var parameters: [String: Any] { get }
}

// MARK: - Endpoint Default Implementations
public extension Endpoint {
    var baseURL: String {
        #if DEBUG
        "https://60c18a34-89cf-4554-b241-cd3cdfcc93ff.mock.pstmn.io/"
        #else
        "https://60c18a34-89cf-4554-b241-cd3cdfcc93ff.mock.pstmn.io/"
        #endif
    }
    
    var parameters: [String: Any] {
        [:]
    }
}
