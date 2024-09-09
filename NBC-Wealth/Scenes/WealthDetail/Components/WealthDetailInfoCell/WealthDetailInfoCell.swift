//
//  WealthDetailInfoCell.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 08/09/2024.
//

import UIKit
import NeoBase

final class WealthDetailInfoCell: BaseTableViewCell, ViewModelProviding {
    var viewModel: WealthDetailInfoCellViewModel? {
        didSet {
            showDepositInfo()
        }
    }
    
    private lazy var rateLabel = NeoLabel()
    
    private lazy var holdingDaysLabel: NeoLabel = {
        let label = NeoLabel()
        label.dispatch(.bindInitialState { state in
            state.scale = .subtitle
            state.textColor = .neo(.text, color: .subtitle)
        })
        
        return label
    }()
    
    private lazy var rateStackView: UIStackView = {
        let stackView = UIStackView(of: rateLabel, holdingDaysLabel)
        stackView.spacing = 12
        stackView.alignment = .bottom
        
        return stackView
    }()
    
    private lazy var rateDescription: NeoLabel = {
        let label = NeoLabel()
        label.dispatch(.bindInitialState { state in
            state.text = "Suku bunga saat ini akan dihitung berdasarkan \"suku bunga dasar + suku bunga tambahan\" dan suku bunga saat roll-over akan dihitung berdasarkan suku bunga yang berlaku di tanggal roll-over."
            state.textColor = .neo(.text, color: .subdued)
            state.scale = .subtitle
        })
        
        return label
    }()
    
    private lazy var contentStackView: VerticalStackView = {
        let stackView = VerticalStackView(of: rateStackView, rateDescription).with(parent: self)
        stackView.spacing = 12
        
        return stackView
    }()
    
    override func setupOnMovedToSuperview() {
        setupView()
    }
}

// MARK: - Private Functionality
private extension WealthDetailInfoCell {
    func setupView() {
        contentStackView.fillSuperview(spacing: 16)
    }
    
    func showDepositInfo() {
        guard let value = viewModel?.rateDescription else {
            return
        }
        
        let producer = AttributedStringProducer(from: value)
            .assign(.foregroundColor(.neo(.text, color: .highlight)))
            .assign(.font(.heading))
            .assign(.font(.tertiary), for: "p.a.")
        
        rateLabel.dispatch(.setAttributedText(producer.get()))
        
        guard let holdingDays = viewModel?.holdingDaysDescription else {
            return
        }
        
        holdingDaysLabel.dispatch(.setText(holdingDays))
    }
}
