//
//  WebViewHeaderView.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 08/09/2024.
//

import UIKit

public final class WebViewHeaderView: BaseView {
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "close")
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = .neo(.text, color: .default)
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var titleLabel: NeoLabel = {
        let label = NeoLabel()
        label.dispatch(.bindInitialState { state in
            state.numberOfLines = 1
        })
        
        return label
    }()
    
    private lazy var headerViewContentStackView: UIStackView = {
        let stackView = UIStackView(of: closeButton, titleLabel).with(parent: contentView)
        stackView.spacing = 12
        
        return stackView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar).with(parent: self)
        progressView.tintColor = .neo(.text, color: .link)
        
        return progressView
    }()
    
    private lazy var contentView = UIView().with(parent: self)
    
    public override func setupOnMovedToSuperview() {
        setupView()
    }
}

// MARK: - Public Functionality
public extension WebViewHeaderView {
    func setProgress(to progress: Float) {
        if progress > 0 {
            progressView.fadeIn()
        }
        
        if progress == 1 {
            progressView.fadeOut() { [weak self] in
                self?.progressView.setProgress(0, animated: false)
            }
        }
        
        progressView.setProgress(progress, animated: true)
    }
    
    func setTitle(to title: String) {
        titleLabel.dispatch(.setText(title))
    }
}

// MARK: - Private Functionality
private extension WebViewHeaderView {
    func setupView() {
        contentView.fillSuperview()
        
        progressView.constraint(\.leadingAnchor, equalTo: leadingAnchor)
        progressView.constraint(\.bottomAnchor, equalTo: bottomAnchor)
        progressView.constraint(\.trailingAnchor, equalTo: trailingAnchor)
        
        closeButton.constraint(\.heightAnchor, constant: 24)
        closeButton.constraint(\.widthAnchor, constant: 24)
        
        headerViewContentStackView.constraint(\.topAnchor, equalTo: contentView.topAnchor, constant: 16)
        headerViewContentStackView.constraint(\.bottomAnchor, equalTo: contentView.bottomAnchor, constant: -16)
        headerViewContentStackView.constraint(\.leadingAnchor, equalTo: contentView.leadingAnchor, constant: 16)
        headerViewContentStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}

// MARK: - Selectors
private extension WebViewHeaderView {
    @objc func didTapCloseButton() {
        parentViewController?.dismiss(animated: true)
    }
}
