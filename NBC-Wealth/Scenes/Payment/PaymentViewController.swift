//
//  PaymentViewController.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 09/09/2024.
//

import Foundation
import NeoBase
import Combine
import UIKit
import Domain

final class PaymentViewController: BaseViewController<PaymentViewModel> {
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var tableView: DiffableTableView<PaymentViewController, PaymentViewController> = {
        let tableView = DiffableTableView<PaymentViewController, PaymentViewController>(
            backgroundColor: .neo(.surface, color: .subdued),
            provider: self
        )
        tableView.register(PaymentCountdownHeaderCell.self, PaymentSelectedPaymentMethodCell.self, PaymentMethodListCell.self)
        
        return tableView.with(parent: view)
    }()
}

// MARK: - Life Cycle
extension PaymentViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }
}

// MARK: - Private Functionality
private extension PaymentViewController {
    func setupViews() {
        title = "Pembayaran"
        
        tableView.constraint(\.leadingAnchor, equalTo: view.leadingAnchor)
        tableView.constraint(\.topAnchor, equalTo: view.safeAreaLayoutGuide.topAnchor)
        tableView.constraint(\.trailingAnchor, equalTo: view.trailingAnchor)
        tableView.constraint(\.bottomAnchor, equalTo: view.bottomAnchor)
    }
    
    func bindViewModel() {
        viewModel.viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.observeViewState(state)
            }
            .store(in: &cancellables)
        
        viewModel.fetchPaymentMethods()
    }
    
    func observeViewState(_ state: PaymentViewState) {
        switch state {
        case .loading:
            debugPrint(state)
        case .methodReceived:
            showPayments()
        case .error(let message):
            debugPrint(message)
        }
    }
    
    func showPayments() {
        let snapshot = viewModel.buildSnapshot()
        tableView.apply(snapshot)
    }
}

// MARK: - DiffableTableViewDataProvider Conformance
extension PaymentViewController: DiffableTableViewDataProvider, DiffableViewScrollDelegate {
    func provideCell(for section: PaymentSection, in item: PaymentItem, at indexPath: IndexPath) -> UITableViewCell? {
        switch item {
        case .countdown(let item, let endDate):
            let viewModel = PaymentCountdownHeaderCellViewModel(orderItem: item, endDate: endDate)
            return tableView.dequeue(PaymentCountdownHeaderCell.self, for: indexPath, with: viewModel)
        case .selectedMethod(let paymentMethod):
            let viewModel = PaymentSelectedPaymentMethodCellViewModel(paymentMethod: paymentMethod)
            return tableView.dequeue(PaymentSelectedPaymentMethodCell.self, for: indexPath, with: viewModel, delegate: self)
        case .methodList(let paymentMethods, let index):
            let viewModel = PaymentMethodListCellViewModel(paymentMethods: paymentMethods, index: index)
            return tableView.dequeue(PaymentMethodListCell.self, for: indexPath, with: viewModel, delegate: self)
        }
    }
    
    func setHeaderView(in section: PaymentSection) -> UIView? {
        switch section {
        case .paymentSelection:
            PaymentHeaderView(section: section)
        default:
            nil
        }
    }
}

// MARK: - PaymentSelectedPaymentMethodCellDelegate Conformance
extension PaymentViewController: PaymentSelectedPaymentMethodCellDelegate {
    func didTapPay() {
        let viewModel = WebViewModel(url: Constant.xenditDemoURL)
        present(WebViewController.self, viewModel: viewModel)
    }
}

// MARK: - PaymentMethodListCellDelegate Conformance
extension PaymentViewController: PaymentMethodListCellDelegate {
    func didSelectPaymentMethod(_ paymentMethod: PaymentMethod) {
        viewModel.selectedPaymentMethod = paymentMethod
        tableView.scroll(to: .countdown, position: .top)
        showPayments()
    }
}
