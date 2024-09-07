//
//  WealthProductCell.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 06/09/2024.
//

import UIKit
import NeoBase

/// A configuration struct for specifying settings related to dashed lines.
public struct LineDashConfiguration {
    /// The line cap style to be used for the dashed line.
    public var lineCap: CAShapeLayerLineCap
    
    /// The dash pattern array specifying the lengths of dashes and gaps.
    public var pattern: [NSNumber]
    
    /// The color of the line.
    public var color: NeoColor<Border>

    /// The width or thickness of the line.
    public var width: CGFloat

    /// Initializes a `LineConfiguration` with optional parameters.
    ///
    /// - Parameters:
    ///   - color: The color of the line or border.
    ///   - width: The width or thickness of the line or border. Default is `1`.
    ///   - lineCap: The line cap style to be used for the dashed line. Default is `.butt`.
    ///   - pattern: The dash pattern array specifying the lengths of dashes and gaps. Default is `[5, 5]`.
    public init(color: NeoColor<Border>,
                width: CGFloat = 1,
                lineCap: CAShapeLayerLineCap = .butt,
                pattern: [NSNumber] = [5, 5]) {
        self.color = color
        self.width = width
        self.lineCap = lineCap
        self.pattern = pattern
    }
}

final class NeoLabel: BaseView {
    private lazy var state = State()
    
    private lazy var label = UILabel().with(parent: self)
    
    enum Scale {
        case title
        case titleAlt
        case subtitle
        case ternary
        
        var font: UIFont {
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
        var text: String?
        var attributedText: NSAttributedString?
        var scale: Scale = .title
        var textAlignment: NSTextAlignment = .left
        var textColor: NeoColor = .neo(.text, color: .default)
    }
    
    override func setupOnMovedToSuperview() {
        label.fillToSuperview()
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

final class NeoButton: BaseView {
    private lazy var state = State()
    private lazy var button = UIButton().with(parent: self)
    
    private lazy var label: NeoLabel = {
        let label = NeoLabel().with(parent: button)
        label.dispatch(.bindInitialState { state in
            state.textAlignment = .center
        })
        
        return label
    }()
    
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
                2
            case .medium:
                12
            case .large:
                16
            }
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
        var text: String?
        var size: Size = .small
        var configuration: Configuration = .primary
        var tapHandler: (() -> Void)?
    }
    
    override func setupOnMovedToSuperview() {
        button.fillToSuperview()
    }
    
    enum Action {
        case bindInitialState((inout State) -> Void)
        case setText(String)
        case setSize(Size)
        case setConfiguration(Configuration)
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
        case .setTapHandler(let tapHandler):
            state.tapHandler = tapHandler
        }
    }
    
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
    
    func setupView() {
        button.fillToSuperview()
        setSpacing()
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.layer.cornerRadius = button.frame.height / 2
    }
}

final class CapsuleView: BaseView {
    var state = State()
    
    struct State {
        var view: UIView?
        var backgroundColor: NeoColor = .neo(.button, color: .important)
        var horizontalSpacing: CGFloat = 8
        var verticalSpacing: CGFloat = 2
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
        state.view?.fillToSuperview(
            horizontalSpacing: state.horizontalSpacing,
            verticalSpacing: state.verticalSpacing
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.cornerRadius = frame.height / 2
    }
}

final class WealthProductCell: BaseTableViewCell, ViewModelProviding, DelegateProviding {
    var viewModel: WealthProductCellViewModel? {
        didSet {
            setupProductView()
        }
    }
    
    weak var delegate: WealthProductCellDelegate?
    
    private lazy var containerView = UIView().with(parent: self)
    
    private lazy var titleLabel: NeoLabel = {
        let label = NeoLabel()
        label.dispatch(.bindInitialState { _ in })
        
        return label
    }()
    
    private lazy var popularCapsuleView: CapsuleView = {
        let label = NeoLabel()
        label.dispatch(.bindInitialState { state in
            state.text = "Populer"
            state.scale = .ternary
            state.textColor = .neo(.text, color: .primary)
        })
        
        let capsuleView = CapsuleView()
        capsuleView.dispatch(.bindInitialState { state in
            state.view = label
        })
        
        capsuleView.alpha = 0
        capsuleView.transform = .init(translationX: -32, y: 0)
        
        return capsuleView
    }()
    
    private lazy var descriptionLabel: NeoLabel = {
        let label = NeoLabel()
        label.dispatch(.bindInitialState { state in
            state.scale = .subtitle
        })
        
        return label
    }()
    
    private lazy var titleDescriptionStackView: VerticalStackView = {
        let titleStackView = UIStackView(of: titleLabel, popularCapsuleView)
        titleStackView.spacing = 8
        
        let stackView = VerticalStackView(of: titleStackView, descriptionLabel).with(parent: containerView)
        stackView.alignment = .leading
        stackView.spacing = 4
        
        return stackView
    }()
    
    private lazy var rateLabel: NeoLabel = {
        let label = NeoLabel()
        label.dispatch(.bindInitialState { _ in })
        
        return label
    }()
    
    private lazy var rateTitle: NeoLabel = {
        let label = NeoLabel()
        label.dispatch(.bindInitialState { state in
            state.text = "Bunga"
            state.scale = .subtitle
            state.textColor = .neo(.text, color: .subdued)
        })
        
        return label
    }()
    
    private lazy var rateInfoStackView: VerticalStackView = {
        let stackView = VerticalStackView(of: rateLabel, rateTitle)
        stackView.alignment = .leading
        stackView.spacing = 2
        
        return stackView
    }()
    
    private lazy var startAmountLabel: NeoLabel = {
        let label = NeoLabel()
        label.dispatch(.bindInitialState { _ in })
        
        return label
    }()
    
    private lazy var startAmountTitle: NeoLabel = {
        let label = NeoLabel()
        label.dispatch(.bindInitialState { state in
            state.text = "Mulai dari"
            state.textColor = .neo(.text, color: .subdued)
            state.scale = .subtitle
        })
        
        return label
    }()
    
    private lazy var startAmountInfoStackView: VerticalStackView = {
        let stackView = VerticalStackView(of: startAmountLabel, startAmountTitle)
        stackView.alignment = .leading
        stackView.spacing = 2
        
        return stackView
    }()
    
    private lazy var callToActionButton: NeoButton = {
        let button = NeoButton()
        button.dispatch(.bindInitialState { state in
            state.text = "Buka"
            state.tapHandler = { [weak self] in
                self?.didTapProductAction()
            }
        })
        
        return button
    }()
    
    func didTapProductAction() {
        guard let product = viewModel?.product else {
            return
        }
        
        delegate?.didTapProductCallToAction(of: product)
    }
    
    private lazy var productInfoStackView: UIStackView = {
        let stackView = UIStackView(of: rateInfoStackView, startAmountInfoStackView, callToActionButton)
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    private lazy var contentStackView: VerticalStackView = {
        let stackView = VerticalStackView(of: titleDescriptionStackView, productInfoStackView)
        stackView.spacing = 16
        
        return stackView.with(parent: containerView)
    }()
    
    
    private lazy var dividerView: NeoDivider = {
        let divider = NeoDivider().with(parent: containerView)
        divider.dispatch(.bindInitialState { _ in })
        
        return divider
    }()
  
    override func setupOnMovedToSuperview() {
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupBorder()
    }
    
    func setupBorder() {
        guard let position = viewModel?.position else {
            return
        }
        
        addRoundedBorder(with: position)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
            
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            setupBorder()
        }
    }
}

// MARK: - Private Functionality
private extension WealthProductCell {
    func setupViews() {
        containerView.fillToSuperview(horizontalSpacing: 16)
        contentStackView.fillToSuperview(horizontalSpacing: 16, verticalSpacing: 16)
    }
    
    func setupProductView() {
        guard let viewModel else {
            return
        }
        
        titleLabel.dispatch(.setText(viewModel.name))
        descriptionLabel.dispatch(.setText(viewModel.description))
        
        setupRate(with: viewModel.rateDescription)
        setupStartingAmount(with: viewModel.startingAmountDescription)
        dividerView.dispatch(.snapToBottom(16))
        dividerView.isHidden = viewModel.position == .last
        popularCapsuleView.isHidden = !viewModel.shouldShowPopular
        descriptionLabel.isHidden = viewModel.shouldHideMarketingPoints
        
        animatePopularView()
    }
    
    func animatePopularView() {
        springAnimation(duration: 1.0) { [weak self] in
            guard let self else {
                return
            }
            
            popularCapsuleView.alpha = 1
            popularCapsuleView.transform = .identity
        }
    }
    
    func setupRate(with value: String) {
        let producer = AttributedStringProducer(from: value)
            .assign(.foregroundColor(.neo(.text, color: .highlight)))
            .assign(.font(NeoLabel.Scale.title.font))
            .assign(.font(NeoLabel.Scale.ternary.font), for: "p.a.")
        
        rateLabel.dispatch(.setAttributedText(producer.get()))
    }
    
    func setupStartingAmount(with value: String) {
        let producer = AttributedStringProducer(from: value)
            .assign(.foregroundColor(.neo(.text, color: .default)))
            .assign(.font(NeoLabel.Scale.titleAlt.font))
        
        startAmountLabel.dispatch(.setAttributedText(producer.get()))
    }
    
    private func addRoundedBorder(with position: ProductPosition) {
        containerView.layer.sublayers?.forEach { 
            if $0 is CAShapeLayer { $0.removeFromSuperlayer() }
        }
        
        let borderWidth: CGFloat = 1
        let cornerRadius: CGFloat = 8
            
        let path = UIBezierPath()
        
        let minX: CGFloat = 0
        let maxX: CGFloat = containerView.bounds.width
        let minY: CGFloat = 0
        let maxY: CGFloat = containerView.bounds.height
            
        func addTopBorder() {
            path.move(to: CGPoint(x: minX, y: minY + cornerRadius))
            path.addArc(withCenter: CGPoint(x: minX + cornerRadius, y: minY + cornerRadius), 
                        radius: cornerRadius,
                        startAngle: .pi, 
                        endAngle: -.pi / 2,
                        clockwise: true)
            path.addLine(to: CGPoint(x: maxX - cornerRadius, y: minY))
            path.addArc(withCenter: CGPoint(x: maxX - cornerRadius, y: minY + cornerRadius), 
                        radius: cornerRadius,
                        startAngle: -.pi / 2,
                        endAngle: 0,
                        clockwise: true)
        }
        
        func addSideBorders() {
            let yStartValue = position == .last || position == .middle ? 0 : cornerRadius
            let yEndValue = position == .first || position == .middle ? 0 : cornerRadius
            
            // Left Bnly
            path.move(to: CGPoint(x: minX, y: minY + yStartValue))
            path.addLine(to: CGPoint(x: minX, y: maxY - yEndValue))
            
            // Right border
            path.move(to: CGPoint(x: maxX, y: minY + yStartValue))
            path.addLine(to: CGPoint(x: maxX, y: maxY - yEndValue))
        }
        
        func addBottomBorder() {
            path.move(to: CGPoint(x: maxX, y: maxY - cornerRadius))
            path.addArc(withCenter: CGPoint(x: maxX - cornerRadius, y: maxY - cornerRadius), 
                        radius: cornerRadius, 
                        startAngle: 0, 
                        endAngle: CGFloat.pi / 2, 
                        clockwise: true)
            path.addLine(to: CGPoint(x: minX + cornerRadius, y: maxY))
            path.addArc(withCenter: CGPoint(x: minX + cornerRadius, y: maxY - cornerRadius), 
                        radius: cornerRadius, 
                        startAngle: CGFloat.pi / 2, 
                        endAngle: CGFloat.pi, 
                        clockwise: true)
        }

        switch position {
        case .first:
            addTopBorder()
            addSideBorders()
        case .middle:
            addSideBorders()
        case .last:
            addBottomBorder()
            addSideBorders()
        }
         
        let borderLayer = CAShapeLayer()
        borderLayer.path = path.cgPath
        borderLayer.lineWidth = borderWidth
        borderLayer.strokeColor = .neo(.border, color: .default)
        borderLayer.fillColor = .neo(.surface, color: .clear)
            
        containerView.layer.addSublayer(borderLayer)
        superview?.clipsToBounds = false
    }
}
