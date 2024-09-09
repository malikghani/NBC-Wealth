//
//  PaymentSelectedPaymentMethodCell.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 09/09/2024.
//

import UIKit
import NeoBase

final class PaymentSelectedPaymentMethodCell: BaseTableViewCell, ViewModelProviding, DelegateProviding {
    var viewModel: PaymentSelectedPaymentMethodCellViewModel? {
        didSet {
            setupSelectedMethod()
        }
    }
    
    weak var delegate: PaymentSelectedPaymentMethodCellDelegate?
    
    private lazy var containerView = UIView().with(parent: self)
    
    private lazy var paymentMethodLabel: NeoLabel = {
        let label = NeoLabel()
        label.dispatch(.bindInitialState { state in
            state.text = "Metode Pembayaran"
            state.scale = .subtitle
            state.textColor = .neo(.text, color: .subdued)
        })
        
        return label
    }()
    
    private lazy var recommendedChipView: NeoChipView = {
        let chipView = NeoChipView()
        chipView.dispatch(.bindInitialState { state in
            state.spacing = 4
            state.title = "Rekomendasi"
            state.backgroundColor = .neo(.surface, color: .recommended)
            state.borderColor = .neo(.border, color: .primary)
            state.textColor = .neo(.text, color: .recommended)
        })
        
        return chipView
    }()
    
    private lazy var paymentMethodLabelStackView: UIStackView = {
        let stackView = UIStackView(of: paymentMethodLabel, recommendedChipView, .init())
        stackView.alignment = .center
        stackView.spacing = 8
        
        return stackView
    }()
    
    private lazy var bookmarkIconView: UIImageView = {
        let imageView = UIImageView(image: .init(named: "bookmark_added"))
        imageView.tintColor = .neo(.text, color: .warning)
        imageView.alpha = 0.05
        imageView.clipsToBounds = true
        
        return imageView.with(parent: containerView)
    }()
    
    private lazy var paymentMethodName: NeoLabel = {
        let label = NeoLabel()
        label.dispatch(.bindInitialState { state in
            state.scale = .title
            state.textColor = .neo(.text, color: .default)
        })
        
        return label
    }()
    
    private lazy var paymentMethodInfo: NeoLabel = {
        let label = NeoLabel()
        label.dispatch(.bindInitialState { state in
            state.scale = .subtitle
            state.textColor = .neo(.text, color: .subdued)
        })
        
        return label
    }()
    
    private lazy var contentStackView: VerticalStackView = {
        let bottomStackView = VerticalStackView(of: paymentMethodName, paymentMethodInfo)
        bottomStackView.spacing = 4
        
        let methodPayStackView = UIStackView(of: bottomStackView, .init(), payButton)
        methodPayStackView.alignment = .center
        
        let stackView = VerticalStackView(of: paymentMethodLabelStackView, methodPayStackView)
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        
        return stackView.with(parent: containerView)
    }()
    
    private lazy var payButton: NeoButton = {
        let button = NeoButton()
        button.dispatch(.bindInitialState { state in
            state.text = "Bayar"
            state.tapHandler = { [weak self] in
                self?.delegate?.didTapPay()
            }
        })
        
        return button
    }()
    
    override func setupOnMovedToSuperview() {
        setupViews()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
            
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            addShadow()
        }
    }
}

// MARK: - Private Functionality
private extension PaymentSelectedPaymentMethodCell {
    func setupViews() {
        surfaceColor = .neo(.surface, color: .clear)
        containerView.fillSuperview(horizontalSpacing: 16, verticalSpacing: 12)
        
        bookmarkIconView.constraint(\.heightAnchor, constant: 72)
        bookmarkIconView.constraint(\.widthAnchor, constant: 72)
        bookmarkIconView.constraint(\.leadingAnchor, equalTo: containerView.leadingAnchor, constant: -4)
        bookmarkIconView.constraint(\.topAnchor, equalTo: containerView.topAnchor, constant: 0)
        
        contentStackView.fillSuperview(spacing: 16)
        addShadow()
        
        recommendedChipView.isHidden = .random()
    }
    
    func setupSelectedMethod() {
        guard let paymentMethod = viewModel?.paymentMethod else {
            return
        }
        
        paymentMethodName.dispatch(.setText(paymentMethod.name))
        paymentMethodInfo.dispatch(.setText(paymentMethod.type.info))
    }
    
    func addShadow() {
        containerView.backgroundColor = .neo(.surface, color: .default)
        containerView.layer.shadowColor = .neo(.surface, color: .shadow)
        containerView.layer.shadowOpacity = 0.15
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 6
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = false
    }
}
