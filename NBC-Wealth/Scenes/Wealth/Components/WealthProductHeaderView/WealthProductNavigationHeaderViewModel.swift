//
//  WealthProductNavigationHeaderViewModel.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 08/09/2024.
//

import Domain

final class WealthProductNavigationHeaderViewModel {
    private(set) var groups: ProductGroups<Wealth>
    
    init(groups: ProductGroups<Wealth>) {
        self.groups = groups
    }
}
