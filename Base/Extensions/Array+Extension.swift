//
//  Array+Extension.swift
//  Base
//
//  Created by Ghani's Mac Mini on 05/09/2024.
//

import Foundation

public extension Array {
    subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        
        return self[index]
    }
}
