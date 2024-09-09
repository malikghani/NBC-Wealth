//
//  WealthDetailCurrencyInputCell.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 09/09/2024.
//

import UIKit
import NeoBase

final class WealthDetailCurrencyInputCell: BaseTableViewCell, ViewModelProviding, DelegateProviding {
    var viewModel: WealthDetailCurrencyInputCellViewModel? {
        didSet {
            showInput()
        }
    }
    
    weak var delegate: WealthDetailCurrencyInputCellDelegate?
    
    private lazy var inputField: NeoCurrencyInputView = {
        let field = NeoCurrencyInputView().with(parent: self)
        field.dispatch(.bindInitialState { state in
            state.amountChangeHandler = { [weak self] amount in
                self?.delegate?.didInputDepositAmount(to: amount)
            }
            state.interactionHandler = { [weak self] isInteractable in
                self?.delegate?.didChangeInputInteraction(to: isInteractable)
            }
        })
        
        return field
    }()
    
    override func setupOnMovedToSuperview() {
        setupView()
    }
}

// MARK: - Private Functionality
private extension WealthDetailCurrencyInputCell {
    func setupView() {
        inputField.fillSuperview(horizontalSpacing: 16, verticalSpacing: 8)
    }
    
    func showInput() {
        guard let viewModel else {
            return
        }
        
        inputField.dispatch(.setMessageText("Minimum deposito \(viewModel.orderItem.product.startingAmount.toIDR())"))
        inputField.dispatch(.inputAction(.setMinimumAmount(viewModel.orderItem.product.startingAmount)))
        inputField.dispatch(.inputAction(.setAmount(viewModel.orderItem.deposit)))
    }
}
