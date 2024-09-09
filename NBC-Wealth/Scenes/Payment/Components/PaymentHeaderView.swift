//
//  PaymentHeaderView.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 09/09/2024.
//

import UIKit
import NeoBase

final class PaymentHeaderView: BaseView {
    private var section: PaymentSection
    
    private lazy var titleLabel: NeoLabel = {
        let label = NeoLabel().with(parent: self)
        label.dispatch(.bindInitialState { _ in })
        
        return label
    }()
    
    init?(section: PaymentSection) {
        guard section.title != nil else {
            return nil
        }
        
        self.section = section
        super.init()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Functionality
private extension PaymentHeaderView {
    func setupViews() {
        surfaceColor = .neo(.surface, color: .clear)
        titleLabel.dispatch(.setText(section.title ?? ""))
        titleLabel.constraint(\.leadingAnchor, equalTo: leadingAnchor, constant: 16)
        titleLabel.constraint(\.topAnchor, equalTo: topAnchor, constant: 12)
        titleLabel.constraint(\.trailingAnchor, equalTo: trailingAnchor, constant: -16)
        titleLabel.constraint(\.bottomAnchor, equalTo: bottomAnchor)
    }
}
