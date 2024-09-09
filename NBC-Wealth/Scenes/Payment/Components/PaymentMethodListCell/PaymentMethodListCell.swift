//
//  PaymentMethodListCell.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 09/09/2024.
//

import UIKit
import NeoBase
import Domain

final class PaymentMethodListCell: BaseTableViewCell, ViewModelProviding, DelegateProviding {
    var viewModel: PaymentMethodListCellViewModel? {
        didSet {
            setupPaymentMethods()
        }
    }
    
    weak var delegate: PaymentMethodListCellDelegate?
    
    private var isExpanded = true
    
    private lazy var containerView = UIView().with(parent: self)
    
    private lazy var paymentMethodName: NeoLabel = {
        let label = NeoLabel()
        label.dispatch(.bindInitialState { state in
            state.scale = .title
            state.textColor = .neo(.text, color: .default)
        })
        
        return label
    }()
    
    private lazy var chevronIcon = UIImageView(image: .init(named: "chevron_up"))
    
    private lazy var paymentMethodNameStackView: UIStackView = {
        let stackView = UIStackView(of: paymentMethodName, chevronIcon)
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    private lazy var paymentMethodDescription: NeoLabel = {
        let label = NeoLabel()
        label.dispatch(.bindInitialState { state in
            state.scale = .subtitle
            state.textColor = .neo(.text, color: .subdued)
        })
        
        return label
    }()
    
    private lazy var contentStackView: VerticalStackView = {
        let stackView = VerticalStackView(of: paymentMethodNameStackView, paymentMethodDescription, methodListStackView)
        stackView.spacing = 4
        stackView.setCustomSpacing(8, after: paymentMethodNameStackView)
        stackView.setCustomSpacing(12, after: paymentMethodDescription)
        
        return stackView.with(parent: containerView)
    }()
    
    private lazy var methodListStackView: VerticalStackView = {
        let stackView = VerticalStackView()
        stackView.spacing = 14
        
        return stackView
    }()
    
    override func setupOnMovedToSuperview() {
        setupView()
    }
}

// MARK: - Private Functionality
private extension PaymentMethodListCell {
    func setupView() {
        surfaceColor = .neo(.surface, color: .clear)
        chevronIcon.tintColor = .neo(.text, color: .default)
        chevronIcon.constraint(\.heightAnchor, constant: 32)
        chevronIcon.constraint(\.widthAnchor, constant: 32)
        containerView.backgroundColor = .neo(.surface, color: .default)
        containerView.fillSuperview(spacing: 16)
        contentStackView.fillSuperview(spacing: 16)
        containerView.layer.cornerRadius = 8
        setupTapGesture()
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapMethodName))
        paymentMethodNameStackView.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapMethodName() {
        guard let tableView = superview as? UITableView else {
            return
        }
        
        HapticProducer.shared.perform(feedback: .selectionChanged)
        
        paymentMethodDescription.setHidden(isExpanded)
        methodListStackView.setHidden(isExpanded)
        
        springAnimation(duration: 0.5, damping: 0.8, velocity: 0.8, animation: { [weak self] in
            guard let self else {
                return
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
            let expandedRotation = CGFloat(180.0 * (.pi / 180.0))
            chevronIcon.transform = isExpanded ? .init(rotationAngle: expandedRotation) : .identity
        })
        
        isExpanded.toggle()
    }
    
    func setupPaymentMethods() {
        guard let viewModel else {
            return
        }
        
        methodListStackView.removeAllArrangedSubviews()
        let paymentMethods = viewModel.paymentMethods
        let methodStackViews = paymentMethods.map(createStackView)
        methodListStackView.addArrangedSubviews(methodStackViews)
        
        paymentMethodName.dispatch(.setText(viewModel.title))
        paymentMethodDescription.dispatch(.setText(viewModel.description))
    }
    
    func createStackView(for method: PaymentMethod) -> UIStackView {
        let icon = UIImageView(image: .init(named: method.icon))
        icon.contentMode = .scaleAspectFit
        icon.constraint(\.heightAnchor, constant: 32)
        icon.constraint(\.widthAnchor, constant: 32)
        
        let titleLabel = NeoLabel()
        titleLabel.dispatch(.bindInitialState { state in
            state.text = method.name
            state.scale = .titleAlt2
            state.textColor = .neo(.text, color: .default)
        })
        
        let stackView = UIStackView(of: icon, titleLabel)
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 14
        
        stackView.addTapGesture { [weak self] in
            HapticProducer.shared.perform(feedback: .selectionChanged)
            self?.delegate?.didSelectPaymentMethod(method)
        }
        
        return stackView
    }
}
