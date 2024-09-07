//
//  NeoTabView.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 08/09/2024.
//

import UIKit

public final class NeoTabView<I: TabItemRepresentable>: BaseView {
    private(set) var state = State()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView().with(parent: self)
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        
        return stackView
    }()
    
    private lazy var divider: NeoDivider = {
        let divider = NeoDivider().with(parent: self)
        divider.dispatch(.bindInitialState { _ in })
        divider.alpha = 0.5
        
        return divider
    }()
    
    private lazy var selectedIndicator: NeoDivider = {
        let divider = NeoDivider().with(parent: self)
        divider.dispatch(.bindInitialState { state in
            state.foregroundColor = self.state.selectedColor
        })
        
        return divider
    }()
}

// MARK: - Public Functionality
public extension NeoTabView {
    struct State {
        public var selectedItem: I?
        public var items: [I] = []
        public var selectedColor: NeoColor = .neo(.border, color: .primary)
        public var height: CGFloat = 72
        public var tapHandler: ((I) -> Void)?
    }
    
    enum Action {
        case bindInitialState((inout State) -> Void)
        case setSelectedItem(I?, callHandler: Bool = true)
        case setItems([I])
        case setSelectedColor(NeoColor<Border>)
        case setHeight(CGFloat)
        case setTapHandler(((I) -> Void)?)
    }
    
    func dispatch(_ action: Action) {
        switch action {
        case .bindInitialState(let builder):
            builder(&state)
            bindInitialState()
        case .setSelectedItem(let item, let shouldCallHandler):
            guard state.selectedItem != item else {
                return
            }
            
            state.selectedItem = item
            moveSelectedIndicator(shouldCallHandler: shouldCallHandler)
        case .setItems(let items):
            state.items = items
            bindItems()
        case .setSelectedColor(let color):
            state.selectedColor = color
            bindSelectedColor()
        case .setHeight(let height):
            state.height = height
            bindHeight()
        case .setTapHandler(let handler):
            state.tapHandler = handler
        }
    }
}

// MARK: - Binding Functionality
private extension NeoTabView {
    func bindInitialState() {
        bindItems()
        bindSelectedColor()
        bindHeight()
    }
    
    func bindItems() {
        contentStackView.removeAllArrangedSubviews()
        let itemViews = state.items.map(createItemView)
        contentStackView.addArrangedSubviews(itemViews)
        setInitialSelectedItem()
    }
    
    func bindSelectedColor() {
        let color = state.selectedColor
        selectedIndicator.dispatch(.setForegroundColor(color))
    }
    
    func bindHeight() {
        contentStackView.removeFromSuperview()
        addSubview(contentStackView)
        contentStackView.fillSuperview()
        contentStackView.constraint(\.heightAnchor, constant: state.height)
        
        divider.dispatch(.snapToBottom())
        addSubview(selectedIndicator)
    }
}

// MARK: - Private Functionality
private extension NeoTabView {
    func setInitialSelectedItem() {
        guard let firstItem = state.items.first else {
            return
        }
        
        dispatch(.setSelectedItem(firstItem))
    }
    
    func createItemView(for item: I) -> NeoTabItemView<I> {
        let itemView = NeoTabItemView<I>()
        itemView.dispatch(.bindInitialState { state in
            state.item = item
            state.tapHandler = { [weak self] item in
                self?.dispatch(.setSelectedItem(item))
                HapticProducer.shared.perform(feedback: .selectionChanged)
            }
        })
        
        return itemView
    }
    
    func moveSelectedIndicator(shouldCallHandler: Bool = true) {
        guard let selectedItem = state.selectedItem else {
            return
        }
        
        for item in state.items {
            let shouldSelected = item == selectedItem
            getTabItemView(for: item)?.dispatch(.setIsSelected(shouldSelected))
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            
            handleTabTap(for: selectedItem)
            shouldCallHandler ? state.tapHandler?(selectedItem) : ()
        }
    }
    
    func handleTabTap(for item: I) {
        guard let currentView = getTabItemView(for: item) else {
            return
        }
        
        let width: CGFloat = 28
        let x = currentView.center.x + (width / 2)
        let yPosition = currentView.center.y + 14
        let frame = CGRect(x: x - width, y: yPosition, width: width, height: 3)
        
        if selectedIndicator.frame == .zero {
            selectedIndicator.center = currentView.center
        }
        
        animateSelectedIndicator(to: frame)
    }
    
    func animateSelectedIndicator(to frame: CGRect) {
        springAnimation(duration: 0.75) { [weak self] in
            guard let self else {
                return
            }
            
            selectedIndicator.frame = frame
            selectedIndicator.clipsToBounds = true
            selectedIndicator.layer.cornerRadius = 1.5
        }
    }
    
    func getTabItemView(for item: I) -> NeoTabItemView<I>? {
        guard let index = state.items.firstIndex(of: item) else {
            return nil
        }
        
        guard let currentView = contentStackView.arrangedSubviews[safe: index] else {
            return nil
        }
        
        return currentView as? NeoTabItemView<I>
    }
}
