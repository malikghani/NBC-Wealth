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
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var tableView: DiffableTableView<WealthDetailViewController, WealthDetailViewController> = {
        let tableView = DiffableTableView<WealthDetailViewController, WealthDetailViewController>(
            backgroundColor: .neo(.surface, color: .subdued),
            provider: self
        )
        tableView.register(WealthDetailInfoCell.self, WealthDetailMiscCell.self)
        
        return tableView.with(parent: view)
    }()
    
    private lazy var footerView = WealthDetailFooterView(delegate: self).with(parent: view)
}

// MARK: - Life Cycle
extension WealthDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
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
    
    func bindViewModel() {
        viewModel.viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.observeViewState(state)
            }
            .store(in: &cancellables)
        
        showWealthDetail()
    }
    
    func observeViewState(_ state: WealthDetailViewState) {
        switch state {
        case .loading:
            break
        case .orderCreated:
            break
        case .error(let message):
            print(message)
        }
    }
    
    func showWealthDetail() {
        let snapshot = viewModel.buildSnapshot()
        tableView.apply(snapshot)
    }
}

// MARK: - DiffableTableViewDataProvider Conformance
extension WealthDetailViewController: DiffableTableViewDataProvider, DiffableViewScrollDelegate {
    func provideCell(for section: WealthDetailSection, in item: WealthDetailItem, at indexPath: IndexPath) -> UITableViewCell? {
        switch item {
        case .info(let item):
            let viewModel = WealthDetailInfoCellViewModel(orderItem: item)
            return tableView.dequeue(WealthDetailInfoCell.self, for: indexPath, with: viewModel)
        case .inputDeposit(let wealth):
            return .init()
        case .preselectInput:
            return .init()
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

// MARK: - WealthDetailFooterViewDelegate Conformance
extension WealthDetailViewController: WealthDetailFooterViewDelegate {
    func didTapActionButton() {
        
    }
    
    func didTapTermsAndConditions() {
        let viewModel = WebViewModel(url: Constant.privacyPolicuURL)
        present(WebViewController.self, viewModel: viewModel)
    }
}
