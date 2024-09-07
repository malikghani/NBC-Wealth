//
//  WealthProductNavigationHeaderview.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 08/09/2024.
//

import UIKit
import Domain
import NeoBase

// MARK: - ProductGroup TabItemRepresentable Conformance
extension ProductGroup: TabItemRepresentable {
    public var title: String {
        name
    }
}

final class WealthProductNavigationHeaderView: BaseView, ViewModelProviding, DelegateProviding {
    var viewModel: WealthProductNavigationHeaderViewModel? {
        didSet {
            setupTabView()
        }
    }
    
    weak var delegate: WealthProductNavigationHeaderViewDelegate?
    
    private lazy var tabView: NeoTabView<ProductGroup<Wealth>> = {
        let tabView = NeoTabView<ProductGroup<Wealth>>().with(parent: self)
        tabView.dispatch(.bindInitialState { state in
            state.tapHandler = { [weak self] item in
                self?.delegate?.didTapProductGroup(of: item)
            }
        })
        
        return tabView
    }()
}

// MARK: - Internal Functionality
extension WealthProductNavigationHeaderView {
    /// Sets the selected item in the tab view.
    ///
    /// - Parameter item: An optional `ProductGroup<Wealth>` representing the item to be selected. If `nil`, no item will be selected.
    func setSelectedItem(to item: ProductGroup<Wealth>?) {
        tabView.dispatch(.setSelectedItem(item, callHandler: false))
    }
}

// MARK: - Private Functionality
private extension WealthProductNavigationHeaderView {
    func setupTabView() {
        let allItems = viewModel?.groups ?? []
        tabView.dispatch(.setItems(allItems))
        tabView.fillSuperview()
    }
}
