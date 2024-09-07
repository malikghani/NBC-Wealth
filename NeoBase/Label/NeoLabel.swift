//
//  NeoLabel.swift
//  NeoBase
//
//  Created by Ghani's Mac Mini on 07/09/2024.
//

import UIKit

public final class NeoLabel: BaseView {
    private lazy var state = State()
    private lazy var label = UILabel().with(parent: self)
    
    public override func setupOnMovedToSuperview() {
        label.fillSuperview()
    }
}

// MARK: - Public Functionality
public extension NeoLabel {
    enum Scale {
        case title
        case titleAlt
        case subtitle
        case ternary
        
        public var font: UIFont {
            switch self {
            case .title:
                .systemFont(ofSize: 16, weight: .semibold)
            case .titleAlt:
                .systemFont(ofSize: 14, weight: .semibold)
            case .subtitle:
                .systemFont(ofSize: 12, weight: .regular)
            case .ternary:
                .systemFont(ofSize: 12, weight: .semibold)
            }
        }
    }

    struct State {
        public var text: String?
        public var attributedText: NSAttributedString?
        public var scale: Scale = .title
        public var textAlignment: NSTextAlignment = .left
        public var textColor: NeoColor = .neo(.text, color: .default)
    }
    
    enum Action {
        case bindInitialState((inout State) -> Void)
        case setText(String?)
        case setAttributedText(NSAttributedString?)
        case setTextAligment(NSTextAlignment)
        case setScale(Scale)
        case setTextColor(NeoColor<Text>)
    }
    
    func dispatch(_ action: Action) {
        switch action {
        case .bindInitialState(let builder):
            builder(&state)
            bindInitialState()
        case .setText(let text):
            state.text = text
            bindText()
        case .setAttributedText(let attributedString):
            state.attributedText = attributedString
            bindText()
        case .setTextAligment(let alignment):
            state.textAlignment = alignment
            bindTextAlignment()
        case .setScale(let typeScale):
            state.scale = typeScale
            bindFont()
        case .setTextColor(let color):
            state.textColor = color
            bindTextColor()
        }
    }
}

// MARK: - Binding Functionality
private extension NeoLabel {
    func bindInitialState() {
        bindText()
        bindFont()
        bindTextColor()
        bindTextAlignment()
        surfaceColor = .neo(.surface, color: .clear)
    }
    
    func bindText() {
        if let attributedText = state.attributedText {
            label.attributedText = attributedText
            return
        }
        
        label.text = state.text
    }
    
    func bindAttributedText() {
        label.attributedText = state.attributedText
    }
    
    func bindTextAlignment() {
        label.textAlignment = state.textAlignment
    }
    
    func bindFont() {
        label.font = state.scale.font
    }
    
    func bindTextColor() {
        label.textColor = state.textColor.value
    }
}
