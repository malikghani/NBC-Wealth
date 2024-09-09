//
//  NeoCurrencyInputView.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 09/09/2024.
//

import UIKit

public final class NeoCurrencyInputView: BaseView {
    private(set) var state = State()
    
    private lazy var inputField: NeoCurrencyInputField = {
        let field = NeoCurrencyInputField()
        field.dispatch(.bindInitialState { state in
            state.errorHandler = { [weak self] error in
                UIView.animate(withDuration: 0.25) {
                    self?.handleInputError(of: error)
                }
            }
        })
        
        return field
    }()
    
    private lazy var messageLabel: NeoLabel = {
        let label = NeoLabel()
        label.dispatch(.bindInitialState { state in
            state.scale = .subtitle
        })
        
        return label
    }()
    
    private lazy var preselectAmountStackView: VerticalStackView = {
        let stackView = VerticalStackView()
        stackView.alignment = .leading
        stackView.spacing = 8
    
        return stackView
    }()
    
    private lazy var contentStackView: VerticalStackView = {
        let stackView = VerticalStackView(of: inputField, messageLabel, preselectAmountStackView)
        stackView.spacing = 8
        
        return stackView.with(parent: self)
    }()
    
    public override func setupOnMovedToSuperview() {
        setupView()
    }
}

// MARK: - Private Functionality
private extension NeoCurrencyInputView {
    func setupView() {
        inputField.constraint(\.heightAnchor, constant: 58)
        contentStackView.fillSuperview()
    }
    
    func handleInputError(of error: NeoCurrencyInputField.InputError?) {
        if let error {
            state.interactionHandler?(false)
            inputField.layer.borderColor = .neo(.text, color: .error)
            messageLabel.dispatch(.setText(error.description, animated: true))
            messageLabel.dispatch(.setTextColor(.neo(.text, color: .error)))
        } else {
            state.interactionHandler?(true)
            let minimumAmount = inputField.textFieldState.minimumAmount.toIDR()
            let message = "Minimum deposito \(minimumAmount)"
            inputField.layer.borderColor = .neo(.border, color: .default)
            messageLabel.dispatch(.setText(message, animated: true))
            messageLabel.dispatch(.setTextColor(.neo(.text, color: .subdued)))
        }
    }
}

// MARK: - Public Functionality
public extension NeoCurrencyInputView {
    struct State {
        public var amountChangeHandler: ((Int64) -> Void)?
        public var interactionHandler: ((Bool) -> Void)?
        public var messageText: String = ""
        public var messageTextColor: NeoColor = .neo(.text, color: .subdued)
    }
    
    enum Action {
        case bindInitialState((inout State) -> Void)
        case inputAction(NeoCurrencyInputField.Action)
        case setAmountChangeHandler(((Int64) -> Void)?)
        case setMessageText(String)
        case setMessageTextColor(NeoColor<Text>)
    }
    
    func dispatch(_ action: Action) {
        switch action {
        case .bindInitialState(let builder):
            builder(&state)
            bindInitialState()
        case .inputAction(let inputAction):
            inputField.dispatch(inputAction)
        case .setAmountChangeHandler(let handler):
            state.amountChangeHandler = handler
            bindAmountChangeHandler()
        case .setMessageText(let messageText):
            state.messageText = messageText
            bindMessageText()
        case .setMessageTextColor(let messageTextColor):
            state.messageTextColor = messageTextColor
            bindMessageTextColor()
        }
    }
}

// MARK: - Binding Functionality
private extension NeoCurrencyInputView {
    func bindInitialState() {
        bindMessageText()
        bindMessageTextColor()
        bindAmountChangeHandler()
        insertPreselectAmounts()
    }
    
    func bindMessageText() {
        messageLabel.dispatch(.setText(state.messageText))
    }
    
    func bindMessageTextColor() {
        messageLabel.dispatch(.setTextColor(state.messageTextColor))
    }
    
    func bindAmountChangeHandler() {
        inputField.dispatch(.setAmountChangeHandler(state.amountChangeHandler))
    }
}

// MARK: - Preselect Amount Functionality
private extension NeoCurrencyInputView {
    func insertPreselectAmounts() {
        let stackViews = Constant.preselectAmount.map { value in
            let chips = value.map(createChipView)
            let stackView = UIStackView(of: chips)
            stackView.spacing = 8
            
            return stackView
        }
   
        preselectAmountStackView.addArrangedSubviews(stackViews)
    }
    
    func createChipView(for value: Int64) -> NeoChipView {
        let chipView = NeoChipView()
        chipView.dispatch(.bindInitialState { state in
            state.title = value.toIDR()
            state.tapHandler = { [weak self] in
                HapticProducer.shared.perform(feedback: .selectionChanged)
                self?.state.amountChangeHandler?(value)
                self?.didTapPreselectAmount(of: value)
            }
        })
        
        return chipView
    }
    
    @objc func didTapPreselectAmount(of amount: Int64) {
        inputField.dispatch(.setAmount(amount))
    }
}
