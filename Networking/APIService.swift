//
//  APIService.swift
//  Networking
//
//  Created by Ghani's Mac Mini on 04/09/2024.
//

import Foundation

public final class APIService<E> where E: Endpoint {
    public init() { }
    
    private func createRequest(from endpoint: E) -> URLRequest? {
        guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if endpoint.method != .GET {
            request.httpBody = try? JSONSerialization.data(withJSONObject: endpoint.parameters, options: [])
        }
        
        return request
    }
    
    public func execute<T: Decodable>(_ endpoint: E, to type: T.Type) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            guard let request = createRequest(from: endpoint) else {
                throwError(.invalidURL, to: continuation)
                return
            }
            
            let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let self else {
                    self?.throwError(.unknownError("Self deinitialized"), to: continuation)
                    return
                }
                
                if let error {
                    throwError(.dataTaskError(error), to: continuation)
                    return
                }
                   
                guard let data else {
                    throwError(.missingData(type), to: continuation)
                    return
                }
               
                do {
                    let response = try decode(from: data, into: type)
                    continuation.resume(returning: response.data)
                } catch let error as DecodingError {
                    throwError(.decodingError(type, error), to: continuation)
                    return
                } catch {
                    throwError(.unknownError("Error decoding the data: \(error.localizedDescription)"), to: continuation)
                    return
                }
            }
            
            task.resume()
        }
    }
    
    func throwError<T>(_ error: NetworkError<T>, to continuation: CheckedContinuation<T, any Error>) {
        continuation.resume(throwing: error)
    }
    
    func decode<T: Decodable>(from data: Data, into decodedObject: T.Type) throws -> Response<T> {
        let decoder = JSONDecoder()
        let response = try decoder.decode(Response<T>.self, from: data)
        
        return response
    }
}
