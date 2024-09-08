//
//  NeoCurrencyInputField.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 09/09/2024.
//

import UIKit
import NeoBase

public final class NeoCurrencyInputField: UITextField {
    private(set) var textFieldState = State()
    
    private lazy var symbolLabel: NeoLabel = {
        let label = NeoLabel().with(parent: self)
        label.dispatch(.bindInitialState { state in
            state.scale = .currency
        })
        
        return label
    }()
    
    private var symbolPadding: UIEdgeInsets {
        let symbolWidth = symbolLabel.frame.width + 16
        return .init(top: .zero, left: symbolWidth, bottom: .zero, right: 16)
    }
}

// MARK: - Private Functionality
private extension NeoCurrencyInputField {
     func setupViews() {
        font = NeoLabel.Scale.currency.font
        tintColor = .neo(.text, color: .link)
        layer.borderColor = .neo(.border, color: .default)
        layer.borderWidth = 1
        layer.cornerRadius = 8
        delegate = self
        
        symbolLabel.constraint(\.leadingAnchor, equalTo: leadingAnchor, constant: 12)
        symbolLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}

// MARK: - Public Functionality
public extension NeoCurrencyInputField {
    enum InputError {
        case invalidMultiplication(Int64)
        case belowMinimum(Int64)
        
        var description: String {
            switch self {
            case .invalidMultiplication(let minimum):
                "Jumlah deposito harus kelipatan dari \(minimum.toIDR())"
            case .belowMinimum(let minimum):
                "Penempatan deposito minimum adalah \(minimum.toIDR())"
            }
        }
    }
    
    enum Currency {
        case idr
        case usd
        case euro
        
        var symbol: String {
            switch self {
            case .idr:
                "Rp"
            case .usd:
                "$"
            case .euro:
                "€"
            }
        }
    }
    
    struct State {
        public var currency: Currency = .idr
        public var amountChangeHandler: ((Int64) -> Void)?
        public var amount: Int64 = 0
        public var maximumAmount: Int64 = 100_000_000_000
        public var minimumAmount: Int64 = 100_000
        public var errorHandler: ((InputError?) -> Void)?
    }
    
    enum Action {
        case bindInitialState((inout State) -> Void)
        case setCurrency(Currency)
        case setAmountChangeHandler(((Int64) -> Void)?)
        case setAmount(Int64)
        case setMaximumAmount(Int64)
        case setMinimumAmount(Int64)
        case setInputErrorHandler(((InputError?) -> Void)?)
    }
    
    func dispatch(_ action: Action) {
        switch action {
        case .bindInitialState(let builder):
            builder(&textFieldState)
            bindInitialState()
        case .setCurrency(let currency):
            textFieldState.currency = currency
            bindCurrency()
        case .setAmountChangeHandler(let handler):
            textFieldState.amountChangeHandler = handler
        case .setAmount(let amount):
            textFieldState.amount = amount
            bindAmount()
        case .setMaximumAmount(let maximumAmount):
            textFieldState.maximumAmount = maximumAmount
            bindMaximumAmount()
        case .setMinimumAmount(let minimumAmount):
            textFieldState.minimumAmount = minimumAmount
            bindMinimumAmount()
        case .setInputErrorHandler(let handler):
            textFieldState.errorHandler = handler
        }
    }
}

// MARK: - Binding Functionality
private extension NeoCurrencyInputField {
    func bindInitialState() {
        bindCurrency()
        bindMaximumAmount()
        bindMinimumAmount()
    }
    
    func bindCurrency() {
        symbolLabel.dispatch(.setText(textFieldState.currency.symbol))
    }
    
    func bindAmount() {
        text = textFieldState.amount.toIDR(usingSymbol: false)
    }
    
    func bindMaximumAmount() { }
    
    func bindMinimumAmount() { }
}

// MARK: - Overriding Functionality
public extension NeoCurrencyInputField {
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupViews()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: symbolPadding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: symbolPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: symbolPadding)
    }
}

// MARK: - UITextFieldDelegate Conformance
extension NeoCurrencyInputField: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text as NSString? else {
            return true
        }

        let newText = currentText.replacingCharacters(in: range, with: string)
        
        guard !newText.isEmpty else {
            return true
        }
        
        let numericCharacters = newText.components(separatedBy: .decimalDigits.inverted).joined()
            
        // Stop input when input non-numeric
        guard let number = Int64(numericCharacters) else {
            return false
        }
        
        // Stop input when reaching maximum amount
        guard number <= textFieldState.maximumAmount else {
            return false
        }
        
        textFieldState.amountChangeHandler?(number)
        
        let formattedText = number.toIDR(usingSymbol: false)
        textField.text = formattedText
        
        if number < textFieldState.minimumAmount {
            textFieldState.errorHandler?(.belowMinimum(textFieldState.minimumAmount))
        } else if !number.isMultiple(of: textFieldState.minimumAmount) {
            textFieldState.errorHandler?(.invalidMultiplication(textFieldState.minimumAmount))
        } else {
            textFieldState.errorHandler?(nil)
        }

        return false
    }
}
