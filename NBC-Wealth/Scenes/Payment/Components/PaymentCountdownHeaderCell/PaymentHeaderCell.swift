//
//  PaymentCountdownHeaderCell.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 09/09/2024.
//

import UIKit
import NeoBase
import Combine

final class PaymentCountdownHeaderCell: BaseTableViewCell, ViewModelProviding {
    private var timerCancellable: AnyCancellable?
    
    var viewModel: PaymentCountdownHeaderCellViewModel? {
        didSet {
            configureHeaderView()
        }
    }
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: .init(named: "payment_background"))
        imageView.contentMode = .scaleAspectFill
        
        return imageView.with(parent: self)
    }()
    
    private lazy var countdownLabel: NeoLabel = {
        let label = NeoLabel()
        label.dispatch(.bindInitialState { state in
            state.text = "Berakhir dalam 24:00:00"
            state.scale = .subtitle
            state.textAlignment = .center
            state.textColor = .neo(.text, color: .warning)
        })
        
        return label
    }()
    
    private lazy var countdownCapsuleView: CapsuleView = {
        let capsuleView = CapsuleView()
        capsuleView.dispatch(.bindInitialState { state in
            state.view = self.countdownLabel
            state.backgroundColor = .neo(.button, color: .clear)
            state.verticalSpacing = 4
            state.horizontalSpacing = 12
        })
        capsuleView.layer.borderColor = .neo(.text, color: .warning)
        capsuleView.layer.borderWidth = 1
        
        return capsuleView
    }()
    
    private lazy var amountLabel: NeoLabel = {
        let label = NeoLabel()
        label.dispatch(.bindInitialState { state in
            state.scale = .currency
            state.textAlignment = .center
            state.textColor = .neo(.text, color: .warning)
        })
        
        return label
    }()
    
    private lazy var descriptionView: UIView = {
        let icon = UIImageView(image: .init(named: "verified"))
        icon.tintColor = .neo(.text, color: .warning)
        icon.constraint(\.widthAnchor, constant: 12)
        icon.constraint(\.heightAnchor, constant: 12)
        
        let label = NeoLabel()
        label.dispatch(.bindInitialState { state in
            state.text = "Transaksimu aman dan terjaga"
            state.scale = .tertiary
            state.textAlignment = .center
            state.textColor = .neo(.text, color: .warning)
        })
        
        let stackView = UIStackView(of: icon, label)
        stackView.spacing = 4
        
        return stackView
    }()
    
    private lazy var contentStackView: VerticalStackView = {
        let stackView = VerticalStackView(of: countdownCapsuleView, amountLabel, descriptionView)
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 12
        
        return stackView.with(parent: self)
    }()
    
    override func setupOnMovedToSuperview() {
        setupViews()
    }
    
    deinit {
        timerCancellable?.cancel()
    }
}

// MARK: - Private Functionality
private extension PaymentCountdownHeaderCell {
    func setupViews() {
        clipsToBounds = true
        backgroundImageView.fillSuperview()
        contentStackView.fillSuperview(spacing: 20)
    }
    
    func configureHeaderView() {
        guard let viewModel else {
            return
        }
        
        amountLabel.dispatch(.setText(viewModel.orderItem.deposit.toIDR()))
        timerCancellable = viewModel.countdownPublisher
            .sink { [weak self] _ in
                self?.updateCountdown()
            }
    }
    
    func updateCountdown() {
        guard let endDate = viewModel?.endDate else {
            return
        }
        
        let timeInterval = endDate.timeIntervalSince(Date())
        
        if timeInterval > 0 {
            let hours = Int(timeInterval) / 3600
            let minutes = (Int(timeInterval) % 3600) / 60
            let seconds = Int(timeInterval) % 60
            
            let text = String(format: "Berakhir dalam %02d:%02d:%02d", hours, minutes, seconds)
            countdownLabel.dispatch(.setText(text, animated: true))
        } else {
            countdownLabel.dispatch(.setText("00:00:00", animated: true))
            parentViewController?.navigationController?.popToRootViewController(animated: true)
        }
    }
}
