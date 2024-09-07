//
//  NeoDivider.swift
//  Base
//
//  Created by Ghani's Mac Mini on 07/09/2024.
//

import UIKit

public final class NeoDivider: BaseView {
    private var state = State()
    
    private lazy var divider = UIView().with(parent: self)
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
            
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            bindStyle()
        }
    }
}

// MARK: - Public Functionality
public extension NeoDivider {
    enum Style {
        case dashed(LineDashConfiguration? = nil)
        case solid
    }
    
    struct State {
        public var height: CGFloat = 1
        public var style: Style = .solid
        public var foregroundColor: NeoColor = .neo(.border, color: .default)
    }
    
    enum Action {
        case bindInitialState((inout State) -> Void)
        case setHeight(CGFloat)
        case setDividerStyle(Style)
        case setForegroundColor(NeoColor<Border>)
        case snapToBottom(CGFloat = 0)
    }
    
    func dispatch(_ action: Action) {
        switch action {
        case .bindInitialState(let builder):
            builder(&state)
            bindInitialState()
        case .setForegroundColor(let color):
            state.foregroundColor = color
            bindForegroundColor()
        case .setDividerStyle(let style):
            state.style = style
            bindStyle()
        case .setHeight(let height):
            state.height = height
            bindDividerHeight()
        case .snapToBottom(let spacing):
            snapToBottom(spacing: spacing)
        }
    }
}

// MARK: - Private Functionality
private extension NeoDivider {
    func setupLayouts() {
        divider.removeFromSuperview()
        addSubview(divider)
        
        divider.fillSuperview()
        divider.constraint(\.heightAnchor, constant: 1)
    }
    
    func snapToBottom(spacing: CGFloat = 0) {
        guard let superview else {
            return
        }
        
        removeFromSuperview()
        superview.addSubview(self)
        
        constraint(\.leadingAnchor, equalTo: superview.leadingAnchor, constant: spacing)
        constraint(\.trailingAnchor, equalTo: superview.trailingAnchor, constant: -spacing)
        constraint(\.bottomAnchor, equalTo: superview.bottomAnchor)
    }
}

// MARK: - Binding Functionality
private extension NeoDivider {
    func bindInitialState() {
        bindDividerHeight()
        bindForegroundColor()
        bindStyle()
    }
    
    func bindDividerHeight() {
        setupLayouts()
        bindStyle()
    }
    
    func bindForegroundColor() {
        switch state.style {
        case .solid:
            divider.layer.removeSublayers(type: CAShapeLayer.self)
            divider.backgroundColor = state.foregroundColor.value
        case .dashed(let configuration):
            DispatchQueue.main.async { [weak self] in
                self?.bindDashedDivider(with: configuration)
            }
        }
    }
    
    func bindStyle() {
        bindForegroundColor()
    }
    
    func bindDashedDivider(with configuration: LineDashConfiguration?) {
        guard let configuration else {
            return
        }
        
        divider.backgroundColor = .clear
        divider.layer.removeSublayers(type: CAShapeLayer.self)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = state.foregroundColor.value.cgColor
        shapeLayer.lineWidth = state.height
        shapeLayer.fillColor = .neo(.surface, color: .clear)
        shapeLayer.lineDashPattern = configuration.pattern
        shapeLayer.lineCap = configuration.lineCap

        let path = CGMutablePath()
        path.addLines(between: [.zero, CGPoint(x: divider.frame.width, y: .zero)])
        shapeLayer.path = path
        divider.layer.addSublayer(shapeLayer)
    }
}
