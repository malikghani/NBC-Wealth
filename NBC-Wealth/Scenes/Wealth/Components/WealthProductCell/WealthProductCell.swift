//
//  WealthProductCell.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 06/09/2024.
//

import UIKit
import NeoBase

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
            state.scale = .tertiary
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
        containerView.fillSuperview(horizontalSpacing: 16)
        contentStackView.fillSuperview(horizontalSpacing: 16, verticalSpacing: 16)
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
            .assign(.font(.title))
            .assign(.font(.tertiary), for: "p.a.")
        
        rateLabel.dispatch(.setAttributedText(producer.get()))
    }
    
    func setupStartingAmount(with value: String) {
        let producer = AttributedStringProducer(from: value)
            .assign(.foregroundColor(.neo(.text, color: .default)))
            .assign(.font(.titleAlt))
        
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
