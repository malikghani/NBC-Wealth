//
//  WealthViewController.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 04/09/2024.
//

import UIKit
import Combine
import Domain
import NeoBase

final class WealthViewController: BaseViewController<WealthViewModel> {
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView().with(parent: view)
        indicatorView.startAnimating()
        indicatorView.tintColor = .neo(.text, color: .default)
        indicatorView.alpha = 1
        
        return indicatorView
    }()

    private lazy var tableView: DiffableTableView<WealthViewController, WealthViewController> = {
        let tableView = DiffableTableView<WealthViewController, WealthViewController>(provider: self, scrollDelegate: self)
        tableView.register(WealthProductCell.self, WealthProductNavigationCell.self)
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
        
        loadingIndicator.center = view.center
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
        case .loading:
            tableView.fadeOut(duration: 0.1)
        case .productsReceived:
            tableView.fadeIn(duration: 0.1)
            tableView.setRefreshControlEndRefresh()
            showProducts()
        case .error(let message):
            debugPrint(message)
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
        let viewModel = WealthDetailViewModel(wealth: product)
        push(WealthDetailViewController.self, viewModel: viewModel)
    }
}

// MARK: - DiffableTableViewDataProvider Conformance
extension WealthViewController: DiffableTableViewDataProvider {
    func provideCell(for section: WealthSection, in item: WealthItem, at indexPath: IndexPath) -> UITableViewCell? {
        switch item {
        case .productNavigation:
            return tableView.dequeue(WealthProductNavigationCell.self, for: indexPath)
        case .product(let wealth, let position):
            let viewModel = WealthProductCellViewModel(product: wealth, position: position)
            return tableView.dequeue(WealthProductCell.self, for: indexPath, with: viewModel, delegate: self)
        }
    }
    
    func setHeaderView(in section: WealthSection) -> UIView? {
        switch section {
        case .productList:
            return WealthProductHeaderView(section: section)
        case .productNavigation(let groups):
            let viewModel = WealthProductNavigationHeaderViewModel(groups: groups)
            let headerView = WealthProductNavigationHeaderView(viewModel: viewModel, delegate: self)
            return headerView
        }
    }
}

// MARK: - DiffableViewScrollDelegate Conformance
extension WealthViewController: DiffableViewScrollDelegate {
    func diffableViewDidScroll(to position: DiffableViewScrollPosition, at section: WealthSection?) {
        guard let section else {
            return
        }
        
        let group = viewModel.getProductGroup(for: section.title)
        (tableView.stickyHeaderView as? WealthProductNavigationHeaderView)?.setSelectedItem(to: group)
    }
}

// MARK: - WealthProductCellDelegate Conformance
extension WealthViewController: WealthProductCellDelegate {
    func didTapProductCallToAction(of product: Wealth) {
        pushProductDetail(with: product)
    }
}

// MARK: - WealthProductNavigationCellDelegate Conformance
extension WealthViewController: WealthProductNavigationHeaderViewDelegate {
    func didTapProductGroup(of productGroup: ProductGroup<Wealth>) {
        tableView.scroll(to: .productList(productGroup.name), position: .top)
    }
}
