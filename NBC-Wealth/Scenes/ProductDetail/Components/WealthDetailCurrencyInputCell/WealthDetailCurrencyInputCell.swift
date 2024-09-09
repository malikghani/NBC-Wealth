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
        inputField.fillSuperview(horizontalSpacing: 16, verticalSpacing: 8)
    }
}

// MARK: - Private Functionality
private extension WealthDetailCurrencyInputCell {
    func showInput() {
        guard let orderItem = viewModel?.orderItem else {
            return
        }
        
        inputField.dispatch(.setMessageText("Minimum deposito \(orderItem.product.startingAmount.toIDR())"))
        inputField.dispatch(.inputAction(.setMinimumAmount(orderItem.product.startingAmount)))
        inputField.dispatch(.inputAction(.setAmount(orderItem.deposit)))
    }
}
