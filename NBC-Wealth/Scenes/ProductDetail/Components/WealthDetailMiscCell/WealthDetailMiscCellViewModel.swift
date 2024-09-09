//
//  WealthDetailMiscCellViewModel.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 08/09/2024.
//

import Foundation

final class WealthDetailMiscCellViewModel {
    private(set) var item: WealthDetailItem
    private(set) var value: String
    
    init(item: WealthDetailItem, value: String) {
        self.item = item
        self.value = value
    }
}
