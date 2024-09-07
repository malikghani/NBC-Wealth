//
//  WealthViewController.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 04/09/2024.
//

import UIKit
import NeoBase
import Combine
import Domain

final class WealthViewController: BaseViewController<WealthViewModel> {
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var tableView: DiffableTableView<WealthViewController, WealthViewController> = {
        let tableView = DiffableTableView<WealthViewController, WealthViewController>(provider: self)
        tableView.register(WealthProductCell.self)
        tableView.setRefreshControl { [weak self] in
            self?.viewModel.fetchProducts()
        }
        
        return tableView.with(parent: view)
    }()
}

// MARK: - Life Cycle
extension WealthViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }
}

// MARK: - Private Functionality
private extension WealthViewController {
    func setupViews() {
        title = "Wealth"
        
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
        
        viewModel.fetchProducts()
    }
    
    func observeViewState(_ state: WealthViewState) {
        switch state {
        case .empty:
            print(state)
        case .loading:
            print(state)
        case .productsReceived:
            tableView.setRefreshControlEndRefresh()
            showProducts()
        case .error(let message):
            print(message)
        }
    }
    
    func showProducts() {
        let snapshot = viewModel.buildSnapshot()
        tableView.apply(snapshot)
    }
}

// MARK: - Navigation Functionality
private extension WealthViewController {
    func pushProductDetail(with product: Wealth) {
        print(#function)
        
        tableView.scroll(to: .productList("Fixed Income"), scrollToTopIfMissing: true)
    }
}

// MARK: - DiffableTableViewDataProvider Conformance
extension WealthViewController: DiffableTableViewDataProvider {
    func provideCell(for section: WealthSection, in item: WealthItem, at indexPath: IndexPath) -> UITableViewCell? {
        switch item {
        case .product(let wealth, let position):
            let viewModel = WealthProductCellViewModel(product: wealth, position: position)
            return tableView.dequeue(WealthProductCell.self, for: indexPath, with: viewModel, delegate: self)
        }
    }
    
    func setHeaderView(in section: WealthSection) -> UIView? {
        WealthProductHeaderView(section: section)
    }
}

// MARK: - DiffableViewScrollDelegate Conformance
extension WealthViewController: DiffableViewScrollDelegate {
    func diffableViewDidScroll(to position: DiffableViewScrollPosition, at section: WealthSection?) {
       
    }
}

// MARK: - WealthProductCellDelegate Conformance
extension WealthViewController: WealthProductCellDelegate {
    func didTapProductCallToAction(of product: Wealth) {
        pushProductDetail(with: product)
    }
}
