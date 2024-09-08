//
//  WebViewModel.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 08/09/2024.
//

public final class WebViewModel {
    private let url: String
    
    public init(url: String) {
        self.url = url
    }
}

// MARK: - Internal Functionality
extension WebViewModel {
    /// A computed property that converts the `url` string into a `URL` object.
    var targetURL: URL? {
        URL(string: url)
    }
}
