//
//  WealthProductNavigationCell.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 08/09/2024.
//

import UIKit
import NeoBase
import Domain

final class WealthProductNavigationCell: BaseTableViewCell { 
    private lazy var containerView = UIView().with(parent: self)
    
    override func setupOnMovedToSuperview() {
        containerView.fillSuperview()
        containerView.constraint(\.heightAnchor, constant: 1)
    }
}

// MARK: - Private Functionality
private extension WealthProductNavigationCell { }
