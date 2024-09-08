//
//  WealthDetailFooterView.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 08/09/2024.
//

import UIKit
import NeoBase

final class WealthDetailFooterView: BaseView, DelegateProviding {
    weak var delegate: WealthDetailFooterViewDelegate?
    
    private var isTermsAndConditionsChecked = true
    
    private(set) lazy var actionButton: NeoButton = {
        let button = NeoButton()
        button.dispatch(.bindInitialState { state in
            state.size = .large
            state.text = "Buka Sekarang"
            state.tapHandler = { [weak self] in
                button.dispatch(.setDisplayState(.loading))
                self?.delegate?.didTapActionButton()
            }
        })
        
        return button
    }()
    
    private lazy var checkMark = UIImageView()
    
    private lazy var termsConditionLabel = NeoLabel()
    
    private lazy var termsConditionStackView: UIStackView = {
        let stackView = UIStackView(of: checkMark, termsConditionLabel)
        stackView.spacing = 4
        stackView.alignment = .center
        
        return stackView
    }()
    
    private lazy var contentStackView: VerticalStackView = {
        let stackView = VerticalStackView(of: actionButton, termsConditionStackView).with(parent: containerView)
        stackView.spacing = 10
        
        return stackView
    }()
    
    private lazy var dividerView: NeoDivider = {
        let divider = NeoDivider().with(parent: containerView)
        divider.dispatch(.bindInitialState { _ in })
        
        return divider
    }()
    
    private lazy var containerView = UIView().with(parent: self)
    
    override func setupOnMovedToSuperview() {
        guard let superview else {
            return
        }
        
        constraint(\.leadingAnchor, equalTo: superview.leadingAnchor)
        constraint(\.trailingAnchor, equalTo: superview.trailingAnchor)
        constraint(\.bottomAnchor, equalTo: superview.bottomAnchor)
        
        setupView()
    }
}

// MARK: - Private Functionality
private extension WealthDetailFooterView {
    func setupView() {
        containerView.constraint(\.topAnchor, equalTo: topAnchor)
        containerView.constraint(\.leadingAnchor, equalTo: leadingAnchor)
        containerView.constraint(\.trailingAnchor, equalTo: trailingAnchor)
        containerView.constraint(\.bottomAnchor, equalTo: safeAreaLayoutGuide.bottomAnchor)
        contentStackView.fillSuperview(spacing: 16)
        
        dividerView.constraint(\.leadingAnchor, equalTo: containerView.leadingAnchor)
        dividerView.constraint(\.topAnchor, equalTo: containerView.topAnchor)
        dividerView.constraint(\.trailingAnchor, equalTo: containerView.trailingAnchor)
        
        setupCheckMark()
        setupTermsCondition()
    }
    
    func setupTermsCondition() {
        checkMark.constraint(\.widthAnchor, constant: 22)
        checkMark.constraint(\.heightAnchor, constant: 22)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCheckMark))
        checkMark.addGestureRecognizer(tapGesture)
        checkMark.isUserInteractionEnabled = true
        
        let depositText = "«Deposito FLEXI TnC»"
        let text = "Saya telah membaca dan menyetujui ‭\(depositText)"
        let producer = AttributedStringProducer(from: text)
            .assign(.font(.subtitle))
            .assign(.font(.ternary), for: depositText)
            .assign(.foregroundColor(.neo(.text, color: .subtitle)))
            .assign(.foregroundColor(.neo(.text, color: .link)), for: depositText)
        termsConditionLabel.dispatch(.setAttributedText(producer.get()))
        
        termsConditionLabel.dispatch(.setTextTapHandlers([depositText: { [weak self] in
            self?.delegate?.didTapTermsAndConditions()
        }]))
    }
    
    @objc private func didTapCheckMark() {
        HapticProducer.shared.perform(feedback: .selectionChanged)
        isTermsAndConditionsChecked.toggle()
        
        transition { [weak self] in
            self?.setupCheckMark()
        }
    }
    
    func setupCheckMark() {
        let isChecked = isTermsAndConditionsChecked
        checkMark.layer.cornerRadius = 11
        checkMark.clipsToBounds = true
        checkMark.image = .init(named: isChecked ? "checkmark_filled" : "checkmark_unfilled")
        checkMark.tintColor = .neo(.button, color: .primary)
        
        actionButton.isUserInteractionEnabled = isChecked
        actionButton.dispatch(.setDisplayState(isChecked ? .active : .disabled))
    }
}
