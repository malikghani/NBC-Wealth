//
//  WealthDetailMiscCell.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 08/09/2024.
//

import UIKit
import NeoBase

final class WealthDetailMiscCell: BaseTableViewCell, ViewModelProviding {
    var viewModel: WealthDetailMiscCellViewModel? {
        didSet {
            showInfo()
        }
    }
    
    private lazy var titleLabel: NeoLabel = {
        let label = NeoLabel().with(parent: self)
        label.dispatch(.bindInitialState { state in
            state.scale = .subtitle
            state.textColor = .neo(.text, color: .subdued)
        })
        
        return label
    }()
    
    private lazy var descriptionLabel: NeoLabel = {
        let label = NeoLabel().with(parent: self)
        label.dispatch(.bindInitialState { state in
            state.textAlignment = .right
        })
        
        return label
    }()
    
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0
        imageView.transform = .init(translationX: 24, y: 0)
        
        return imageView
    }()
    
    private lazy var chevronIcon = UIImageView(image: .init(named: "chevron_right"))

    private lazy var contentStackView: UIStackView = {
        let descriptionStackView = UIStackView(of: iconView, descriptionLabel, chevronIcon)
        descriptionStackView.spacing = 4
        descriptionStackView.setCustomSpacing(8, after: iconView)
        
        let stackView = UIStackView(of: titleLabel, descriptionStackView)
        stackView.distribution = .equalSpacing
        
        return stackView.with(parent: self)
    }()
    
    private lazy var dividerView: NeoDivider = {
        let divider = NeoDivider().with(parent: self)
        divider.dispatch(.bindInitialState { _ in })
        divider.alpha = 0.75
        
        return divider
    }()
    
    override func setupOnMovedToSuperview() {
        setupView()
    }
}

// MARK: - Private Funcionality
private extension WealthDetailMiscCell {
    func setupView() {
        iconView.constraint(\.heightAnchor, constant: 24)
        iconView.constraint(\.widthAnchor, constant: 24)
        contentStackView.fillSuperview(spacing: 16)
        dividerView.dispatch(.snapToBottom(16))
        chevronIcon.tintColor = .neo(.text, color: .default)
    }
    
    func showInfo() {
        guard let viewModel else {
            return
        }
        
        titleLabel.dispatch(.setText(viewModel.item.title))
        descriptionLabel.dispatch(.setScale(viewModel.item.typeScale))
        descriptionLabel.dispatch(.setText(viewModel.value))
        iconView.image = viewModel.item.icon
        chevronIcon.isHidden = !viewModel.item.shouldShowChevron
        dividerView.isHidden = viewModel.item.shouldHideDivider
        dividerView.dispatch(.setDividerStyle(viewModel.item.dividerStyle))
        
        animateIconView()
    }
    
    func animateIconView() {
        guard iconView.image != nil else {
            return
        }
        
        springAnimation(duration: 1.0, delay: 0.2) { [weak self] in
            guard let self else {
                return
            }
            
            iconView.alpha = 1
            iconView.transform = .identity
        }
    }
}
