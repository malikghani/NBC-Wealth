//
//  NetworkError.swift
//  Networking
//
//  Created by Ghani's Mac Mini on 05/09/2024.
//

import Foundation

/// Represents various network-related errors that may occur during a network request.
enum NetworkError<D> where D: Decodable {
    /// An error that occurred during the data task execution.
    ///
    /// - Parameter error: The underlying error that caused the failure.
    case dataTaskError(Error)
    
    /// Indicates that the required data is missing.
    ///
    /// - Parameter type: The expected type of the missing data.
    case missingData(_ type: D.Type)
    
    /// A decoding error that occurred when attempting to decode the response data.
    ///
    /// - Parameters:
    ///   - type: The expected type of data being decoded.
    ///   - error: The specific decoding error that occurred.
    case decodingError(_ type: D.Type, DecodingError)
    
    /// Indicates that a URL could not be created or was invalid.
    case invalidURL
    
    /// An unknown error occurred with an associated message.
    ///
    /// - Parameter message: A description of the unknown error.
    case unknownError(String)
}

// MARK: LocalizedError Conformance
extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .dataTaskError(let error):
            "Error when performing data task: \(error.localizedDescription)"
        case .missingData(let type):
            "Data is missing from respone when parsing for \(type)"
        case .decodingError(let type, let error):
            createDecodingErrorDescription(type, for: error)
        case .invalidURL:
            "Failed to create a valid URL from the endpoint"
        case .unknownError(let message):
            message
        }
    }
}

// MARK: - Private Functionality
private extension NetworkError {
    /// Creates a human-readable description for a decoding error.
    ///
    /// This method generates a descriptive string representation of a decoding error, including details
    /// about the type being decoded and the specific decoding error encountered.
    ///
    /// - Parameters:
    ///   - type: The type being decoded, conforming to the `Decodable` protocol.
    ///   - error: The decoding error that occurred during the decoding process.
    /// - Returns: A human-readable description of the decoding error.
    func createDecodingErrorDescription(_ type: Decodable.Type, for error: DecodingError) -> String {
        switch error {
        case .typeMismatch(let type, let context):
            "Decoding of '\(type)' failed due to a type mismatch. Details: \(context.debugDescription)"
        case .valueNotFound(let type, let context):
            "Decoding of '\(type)' failed due to value not found. Details: \(context.debugDescription)"
        case .keyNotFound(let codingKey, _):
            "Decoding of '\(type)' failed due to no value associated with key '\(codingKey.stringValue)'."
        case .dataCorrupted(let context):
            "Decoding of '\(type)' failed due to data corrupted. Details: \(context.debugDescription)"
        @unknown default:
            "Unknown decoding error"
        }
    }
}
