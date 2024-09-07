//
//  WealthProductHeaderView.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 07/09/2024.
//

import NeoBase

final class WealthProductHeaderView: BaseView {
    private var section: WealthSection
    
    private lazy var titleLabel: NeoLabel = {
        let label = NeoLabel().with(parent: self)
        label.dispatch(.bindInitialState { state in
            state.scale = .title
        })
        
        return label
    }()
    
    init?(section: WealthSection) {
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
private extension WealthProductHeaderView {
    func setupViews() {
        titleLabel.dispatch(.setText(section.title ?? ""))
        titleLabel.fillSuperview(horizontalSpacing: 16, verticalSpacing: 12)
    }
}
