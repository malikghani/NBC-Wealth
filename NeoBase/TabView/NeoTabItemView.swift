//
//  NeoTabItemView.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 08/09/2024.
//

import UIKit

public final class NeoTabItemView<I: TabItemRepresentable>: BaseView {
    private(set) var state = State()
    
    private lazy var label: NeoLabel = {
        let label = NeoLabel().with(parent: self)
        label.dispatch(.bindInitialState { state in
            state.scale = .ternary
            state.textAlignment = .center
        })
        
        return label
    }()
  
    func setupView() {
        label.fillSuperview()
    }
    
    @objc private func handleTapGesture() {
        guard let item = state.item else {
            return
        }
        
        state.tapHandler?(item)
    }
}

// MARK: - Public Functionality
public extension NeoTabItemView {
    struct State {
        public var isSelected = false
        public var item: I?
        public var tapHandler: ((I) -> Void)?
    }
    
    enum Action {
        case bindInitialState((inout State) -> Void)
        case setIsSelected(Bool)
        case setItem(I)
        case setTapHandler(((I) -> Void)?)
    }
    
    func dispatch(_ action: Action) {
        switch action {
        case .bindInitialState(let builder):
            builder(&state)
            bindInitialState()
        case .setIsSelected(let isSelected):
            state.isSelected = isSelected
            bindSelectedItem()
        case .setItem(let value):
            state.item = value
            bindItem()
        case .setTapHandler(let handler):
            state.tapHandler = handler
            bindTapHandler()
        }
    }
}

// MARK: - Binding Functionality
private extension NeoTabItemView {
    func bindInitialState() {
        setupView()
        bindItem()
        bindSelectedItem()
        bindTapHandler()
    }
    
    func bindItem() {
        let title = state.item?.title
        label.dispatch(.setText(title))
    }
    
    func bindSelectedItem() {
        transition({ [weak self] in
            guard let self else {
                return
            }
            
            let isSelected = state.isSelected
            label.dispatch(.setTextColor(.neo(.text, color: isSelected ? .default : .subdued)))
            label.dispatch(.setScale(isSelected ? .ternary : .subtitle))
        }, options: [.transitionCrossDissolve, .curveEaseInOut])
    }
    
    func bindTapHandler() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        addGestureRecognizer(tapGesture)
    }
}
