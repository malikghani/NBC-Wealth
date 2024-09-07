//
//  BaseView.swift
//  Base
//
//  Created by Ghani's Mac Mini on 07/09/2024.
//

import UIKit
import NeoBase

/// A default view with common setup procedures.
open class BaseView: UIView {
    /// The surface color of the view.
    ///
    /// This property is overridden to provide a default `.surfaceDefault` background color.
    ///
    /// - Note: Setting a new background color will update the appearance of the view.
    open var surfaceColor: NeoColor = .neo(.surface, color: .default) {
        didSet {
            super.backgroundColor = surfaceColor.value
        }
    }
    
    /// Performs initial setup for the view.
    open func setupOnInit() {
        backgroundColor = surfaceColor.value
    }
    
    /// Performs setup when the view is moved to a superview.
    open func setupOnMovedToSuperview() { }
    
    /// Initializes the view with default background color.
    ///
    /// Automatically call setupOnInit on post init.
    public init() {
        super.init(frame: .zero)
        setupOnInit()
    }
    
    /// Notifies the view that it has been moved to a new superview.
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupOnMovedToSuperview()
    }

    /// Initializes the view from data in a given unarchiver.
    ///
    /// - Parameter coder: An archiver object.
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupOnInit()
    }
}
