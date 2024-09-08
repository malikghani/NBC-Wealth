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
    
    /// A dictionary type representing text tap handlers.
    public typealias TextTapHandlers = [String: () -> Void]
    
    public override func setupOnMovedToSuperview() {
        label.fillSuperview()
    }
}

// MARK: - Public Functionality
public extension NeoLabel {
    enum Scale {
        case currency
        case heading
        case title
        case titleAlt
        case subtitle
        case ternary
        
        public var font: UIFont {
            switch self {
            case .currency:
                .systemFont(ofSize: 22, weight: .semibold)
            case .heading:
                .systemFont(ofSize: 18, weight: .semibold)
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
        public var numberOfLines: Int = 0
        public var textAlignment: NSTextAlignment = .left
        public var textColor: NeoColor = .neo(.text, color: .default)
        public var tapHandlers: TextTapHandlers = [:]
    }
    
    enum Action {
        case bindInitialState((inout State) -> Void)
        case setText(String?, animated: Bool = false)
        case setAttributedText(NSAttributedString?)
        case setTextAligment(NSTextAlignment)
        case setNumberOfLines(Int)
        case setScale(Scale)
        case setTextColor(NeoColor<Text>)
        case setTextTapHandlers(TextTapHandlers)
    }
    
    func dispatch(_ action: Action) {
        switch action {
        case .bindInitialState(let builder):
            builder(&state)
            bindInitialState()
        case .setText(let text, let animated):
            state.text = text
            if animated {
                transition { [weak self] in
                    self?.bindText()
                }
            } else {
                bindText()
            }
        case .setAttributedText(let attributedString):
            state.attributedText = attributedString
            bindText()
        case .setTextAligment(let alignment):
            state.textAlignment = alignment
            bindTextAlignment()
        case .setScale(let typeScale):
            state.scale = typeScale
            bindFont()
        case .setNumberOfLines(let numberOfLines):
            state.numberOfLines = numberOfLines
            bindNumberOfLines()
        case .setTextColor(let color):
            state.textColor = color
            bindTextColor()
        case .setTextTapHandlers(let tapHandlers):
            state.tapHandlers = tapHandlers
            bindTextTapHandlers()
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
        label.numberOfLines = 0
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
    
    func bindNumberOfLines() {
        label.numberOfLines = state.numberOfLines
    }
    
    func bindTextColor() {
        label.textColor = state.textColor.value
    }
    
    func bindTextTapHandlers() {
        guard !state.tapHandlers.isEmpty, state.attributedText != nil else {
            return
        }
        
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        addGestureRecognizer(tapGesture)
    }
}

// MARK: - Bricks Label Text Tap Functionality
private extension NeoLabel {
    @objc func labelTapped(_ gesture: UITapGestureRecognizer) {
        guard let text = label.text else {
            return
        }
        
        for keyHandler in state.tapHandlers.keys {
            let textRange = (text as NSString).range(of: keyHandler)
            
            if gesture.didTapAttributedText(in: label, ofRange: textRange) {
                state.tapHandlers[keyHandler]?()
                return
            }
        }
    }
}
