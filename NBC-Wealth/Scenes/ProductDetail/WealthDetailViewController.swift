//
//  WealthDetailViewController.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 08/09/2024.
//

import UIKit
import NeoBase
import Combine

final class WealthDetailViewController: BaseViewController<WealthDetailViewModel> {
    private lazy var tableView: DiffableTableView<WealthDetailViewController, WealthDetailViewController> = {
        let tableView = DiffableTableView<WealthDetailViewController, WealthDetailViewController>(
            backgroundColor: .neo(.surface, color: .subdued),
            provider: self
        )
        tableView.register(WealthDetailInfoCell.self, WealthDetailCurrencyInputCell.self, WealthDetailMiscCell.self)
        
        return tableView.with(parent: view)
    }()
    
    private lazy var footerView = WealthDetailFooterView(delegate: self).with(parent: view)
}

// MARK: - Life Cycle
extension WealthDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        showWealthDetail()
    }
}

// MARK: - Private Functionality
private extension WealthDetailViewController {
    func setupViews() {
        tableView.constraint(\.leadingAnchor, equalTo: view.leadingAnchor)
        tableView.constraint(\.topAnchor, equalTo: view.safeAreaLayoutGuide.topAnchor)
        tableView.constraint(\.trailingAnchor, equalTo: view.trailingAnchor)
        tableView.constraint(\.bottomAnchor, equalTo: footerView.topAnchor)
    }
    
    func showWealthDetail() {
        let snapshot = viewModel.buildSnapshot()
        tableView.apply(snapshot)
    }
}

// MARK: - Navigation Functionality
private extension WealthDetailViewController {
    func pushPayment() {
        let viewModel = PaymentViewModel(orderItem: viewModel.orderItem)
        push(PaymentViewController.self, viewModel: viewModel)
        footerView.actionButton.dispatch(.setDisplayState(.active))
    }
}

// MARK: - DiffableTableViewDataProvider Conformance
extension WealthDetailViewController: DiffableTableViewDataProvider, DiffableViewScrollDelegate {
    func provideCell(for section: WealthDetailSection, in item: WealthDetailItem, at indexPath: IndexPath) -> UITableViewCell? {
        switch item {
        case .info(let item):
            let viewModel = WealthDetailInfoCellViewModel(orderItem: item)
            return tableView.dequeue(WealthDetailInfoCell.self, for: indexPath, with: viewModel)
        case .inputDeposit(let item):
            let viewModel = WealthDetailCurrencyInputCellViewModel(orderItem: item)
            return tableView.dequeue(WealthDetailCurrencyInputCell.self, for: indexPath, with: viewModel, delegate: self)
        case .coupon:
            let viewModel = WealthDetailMiscCellViewModel(item: item, value: "Dapat dilihat setelah login")
            return tableView.dequeue(WealthDetailMiscCell.self, for: indexPath, with: viewModel)
        case .estimatedInterest(let value), .rolloverOption(let value), .coins(let value), .maturityDate(let value):
            let viewModel = WealthDetailMiscCellViewModel(item: item, value: value)
            return tableView.dequeue(WealthDetailMiscCell.self, for: indexPath, with: viewModel)
        }
    }
    
    func setHeaderView(in section: WealthDetailSection) -> UIView? {
        WealthDetailHeaderView(section: section)
    }
    
    func setFooterView(in section: WealthDetailSection) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .neo(.surface, color: .subdued)
        
        return footerView
    }
    
    func setFooterViewHeight(in section: WealthDetailSection) -> CGFloat {
        12
    }
}

// MARK: - WealthDetailCurrencyInputCellDelegate Conformance
extension WealthDetailViewController: WealthDetailCurrencyInputCellDelegate {
    func didChangeInputInteraction(to isInteractable: Bool) {
        footerView.actionButton.dispatch(.setDisplayState(isInteractable ? .active : .disabled))
    }
    
    func didInputDepositAmount(to amount: Int64) {
        viewModel.setValue(\.deposit, value: amount)
        showWealthDetail()
    }
}

// MARK: - WealthDetailFooterViewDelegate Conformance
extension WealthDetailViewController: WealthDetailFooterViewDelegate {
    func didTapActionButton() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.pushPayment()
        }
    }
    
    func didTapTermsAndConditions() {
        let viewModel = WebViewModel(url: Constant.privacyPolicyURL)
        present(WebViewController.self, viewModel: viewModel)
    }
}
