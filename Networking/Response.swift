//
//  Response.swift
//  Networking
//
//  Created by Ghani's Mac Mini on 05/09/2024.
//

import Foundation

public struct Response<D>: Decodable where D: Decodable {
    public private(set) var data: D
    let error: String
    let statusCode: Int
    
    enum CodingKeys: CodingKey {
        case data
        case error
        case statusCode
    }
    
    // The provided mock API contains only `data`. However, it is advisable to handle other potential errors or status codes as well.
    // Therefore, I have hardcoded it to fit the context mentioned earlier.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decode(D.self, forKey: .data)
        self.error = try container.decodeIfPresent(String.self, forKey: .error) ?? "Insufficient access to the resource"
        self.statusCode = try container.decodeIfPresent(Int.self, forKey: .statusCode) ?? 403
    }
}
