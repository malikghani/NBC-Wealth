//
//  NeoChipView.swift
//  NeoBase
//
//  Created by Ghani's Mac Mini on 09/09/2024.
//

import UIKit

public final class NeoChipView: BaseView {
    private(set) var state = State()
    
    private lazy var titleLabel: NeoLabel = {
        let label = NeoLabel().with(parent: self)
        label.dispatch(.bindInitialState { state in
            state.scale = .subtitle
        })
        
        return label
    }()
    
    public override func setupOnMovedToSuperview() {
        setupView()
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
            
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            bindBorderColor()
        }
    }
}

// MARK: - Private Functionality
private extension NeoChipView {
    func setupView() {
        clipsToBounds = true
        layer.cornerRadius = 4
        layer.borderWidth = 1
        layer.borderColor = state.borderColor.value.cgColor
        titleLabel.dispatch(.setText(state.title))
        titleLabel.dispatch(.setTextColor(state.textColor))
        backgroundColor = state.backgroundColor.value
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapChipView))
        addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapChipView() {
        state.tapHandler?()
    }
}

// MARK: - Public Functionality
public extension NeoChipView {
    struct State {
        public var title = ""
        public var textColor:  NeoColor = .neo(.text, color: .default)
        public var borderColor: NeoColor = .neo(.border, color: .default)
        public var backgroundColor: NeoColor = .neo(.surface, color: .default)
        public var spacing: CGFloat = 6
        public var tapHandler: (() -> Void)?
    }
    
    enum Action {
        case bindInitialState((inout State) -> Void)
        case setTitle(String)
        case setTextColor(NeoColor<Text>)
        case setBorderColor(NeoColor<Border>)
        case setBackgroundColor(NeoColor<Surface>)
        case setSpacing(CGFloat)
        case setTapHandler((() -> Void)?)
    }
    
    func dispatch(_ action: Action) {
        switch action {
        case .bindInitialState(let builder):
            builder(&state)
            bindInitialState()
        case .setTitle(let title):
            state.title = title
            bindTitle()
        case .setTextColor(let textColor):
            state.textColor = textColor
            bindTextColor()
        case .setBorderColor(let borderColor):
            state.borderColor = borderColor
            bindBorderColor()
        case .setBackgroundColor(let backgroundColor):
            state.backgroundColor = backgroundColor
            bindBackgroundColor()
        case .setSpacing(let spacing):
            state.spacing = spacing
            bindSpacing()
        case .setTapHandler(let tapHandler):
            state.tapHandler = tapHandler
        }
    }
}

// MARK: - Binding Functionality
private extension NeoChipView {
    func bindInitialState() {
        bindTextColor()
        bindBorderColor()
        bindBackgroundColor()
        bindSpacing()
    }
    
    func bindTitle() {
        titleLabel.dispatch(.setText(state.title))
    }
    
    func bindTextColor() {
        titleLabel.dispatch(.setTextColor(state.textColor))
    }
        
    func bindBorderColor() {
        layer.borderColor = state.borderColor.value.cgColor
    }
            
    func bindBackgroundColor() {
        backgroundColor = state.backgroundColor.value
    }
    
    func bindSpacing() {
        titleLabel.removeFromSuperview()
        addSubview(titleLabel)
        titleLabel.fillSuperview(spacing: state.spacing)
    }
}
