//
//  CapsuleView.swift
//  NeoBase
//
//  Created by Ghani's Mac Mini on 07/09/2024.
//

import UIKit

public final class CapsuleView: BaseView {
    private(set) var state = State()
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.cornerRadius = frame.height / 2
    }
}

// MARK: - Public Functionality
public extension CapsuleView {
    struct State {
        public var view: UIView?
        public var backgroundColor: NeoColor = .neo(.button, color: .important)
        public var horizontalSpacing: CGFloat = 8
        public var verticalSpacing: CGFloat = 2
    }
    
    enum Action {
        case bindInitialState((inout State) -> Void)
        case setView(UIView)
        case setBackgroundColor(NeoColor<Button>)
        case setHorizontalSpacing(CGFloat)
        case setVerticalSpacing(CGFloat)
    }
    
    func dispatch(_ action: Action) {
        switch action {
        case .bindInitialState(let builder):
            builder(&state)
            bindInitialState()
        case .setView(let view):
            state.view = view
        case .setBackgroundColor(let color):
            state.backgroundColor = color
        case .setHorizontalSpacing(let horizontalSpacing):
            state.horizontalSpacing = horizontalSpacing
        case .setVerticalSpacing(let verticalSpacing):
            state.verticalSpacing = verticalSpacing
        }
    }
}

// MARK: - Binding Functionality
private extension CapsuleView {
    func bindInitialState() {
        bindView()
        bindBackgroundColor()
        bindSpacing()
    }
    
    func bindView() {
        guard let view = state.view else {
            return
        }
        
        subviews.forEach {
            $0.removeFromSuperview()
        }
        
        addSubview(view)
    }
    
    func bindBackgroundColor() {
        backgroundColor = state.backgroundColor.value
    }
    
    func bindSpacing() {
        bindView()
        state.view?.fillSuperview(
            horizontalSpacing: state.horizontalSpacing,
            verticalSpacing: state.verticalSpacing
        )
    }
}
