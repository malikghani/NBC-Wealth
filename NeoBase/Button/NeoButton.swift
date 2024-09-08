//
//  NeoButton.swift
//  NeoBase
//
//  Created by Ghani's Mac Mini on 07/09/2024.
//

import UIKit

public final class NeoButton: BaseView {
    private lazy var state = State()
    private lazy var button = UIView().with(parent: self)
    
    private lazy var label: NeoLabel = {
        let label = NeoLabel().with(parent: button)
        label.dispatch(.bindInitialState { state in
            state.textAlignment = .center
        })
        
        return label
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView().with(parent: button)
        indicatorView.startAnimating()
        indicatorView.tintColor = .neo(.text, color: .default)
        indicatorView.alpha = 0
        
        return indicatorView
    }()

    public override func setupOnMovedToSuperview() {
        button.fillSuperview()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        button.layer.cornerRadius = button.frame.height / 2
        loadingIndicator.center = button.center
    }
}

// MARK: - Public Functionality
public extension NeoButton {
    enum Size {
        case small
        case medium
        case large
        
        var font: NeoLabel.Scale {
            switch self {
            case .small:
                .titleAlt
            case .medium:
                .titleAlt
            case .large:
                .title
            }
        }
        
        var spacing: CGFloat {
            switch self {
            case .small:
                4
            case .medium:
                8
            case .large:
                12
            }
        }
    }
    
    enum DisplayState {
        case active
        case disabled
        case loading
        
        var shouldInteract: Bool {
            self != .loading
        }
        
        var shouldShowLoading: Bool {
            self == .loading
        }
    }
    
    enum Configuration {
        case primary
        
        var textColor: NeoColor<Text> {
            switch self {
            case .primary:
                .neo(.text, color: .default)
            }
        }
        
        var backgroundColor: NeoColor<Button> {
            switch self {
            case .primary:
                .neo(.button, color: .primary)
            }
        }
    }
    
    struct State {
        public var text: String?
        public var size: Size = .small
        public var configuration: Configuration = .primary
        public var displayState: DisplayState = .active
        public var tapHandler: (() -> Void)?
    }
    
    enum Action {
        case bindInitialState((inout State) -> Void)
        case setText(String)
        case setSize(Size)
        case setConfiguration(Configuration)
        case setDisplayState(DisplayState)
        case setTapHandler((() -> Void)?)
    }
    
    func dispatch(_ action: Action) {
        switch action {
        case .bindInitialState(let builder):
            builder(&state)
            bindInitialState()
        case .setText(let text):
            state.text = text
            bindText()
        case .setSize(let size):
            state.size = size
            bindSize()
        case .setConfiguration(let configuration):
            state.configuration = configuration
            bindConfiguration()
        case .setDisplayState(let displayState):
            state.displayState = displayState
            bindDisplayState()
        case .setTapHandler(let tapHandler):
            state.tapHandler = tapHandler
        }
    }
}

// MARK: - Binding Functionality
private extension NeoButton {
    func bindInitialState() {
        bindText()
        bindSize()
        bindConfiguration()
        setTapGesture()
    }
    
    func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapButton))
        button.addGestureRecognizer(tapGesture)
    }
    
    func setSpacing() {
        label.removeFromSuperview()
        button.addSubview(label)
        
        label.constraint(\.topAnchor, equalTo: button.topAnchor, constant: state.size.spacing)
        label.constraint(\.bottomAnchor, equalTo: button.bottomAnchor, constant: -state.size.spacing)
        label.constraint(\.leadingAnchor, equalTo: button.leadingAnchor, priority: .defaultHigh, constant: 16)
        label.constraint(\.trailingAnchor, equalTo: button.trailingAnchor, priority: .defaultHigh, constant: -16)
    }
    
    @objc private func didTapButton() {
        state.tapHandler?()
    }
    
    func bindText() {
        label.dispatch(.setText(state.text ?? ""))
    }
    
    func bindSize() {
        label.dispatch(.setScale(state.size.font))
        setSpacing()
    }
    
    func bindConfiguration() {
        button.backgroundColor = state.configuration.backgroundColor.value
        label.dispatch(.setTextColor(state.configuration.textColor))
    }
    
    func toggleLoadingIndicator() {
        if state.displayState.shouldShowLoading {
            loadingIndicator.fadeIn(duration: 0.25)
        } else {
            loadingIndicator.fadeOut(duration: 0.25)
        }
    }
    
    func bindDisplayState() {
        toggleLoadingIndicator()
        isUserInteractionEnabled = state.displayState.shouldInteract
        
        switch state.displayState {
        case .active:
            label.fadeIn(duration: 0.25)
            bindConfiguration()
        case .disabled:
            label.fadeIn(duration: 0.25)
            button.backgroundColor = .neo(.button, color: .disabled)
            label.dispatch(.setTextColor(.neo(.text, color: .disabled)))
        case .loading:
            label.fadeOut(duration: 0.25)
            button.backgroundColor = .neo(.button, color: .disabled)
        }
    }
}
