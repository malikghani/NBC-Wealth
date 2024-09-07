//
//  BaseTableViewCell.swift
//  Base
//
//  Created by Ghani's Mac Mini on 06/09/2024.
//

import UIKit
import NeoBase

/// A default table view cell with common setup procedures.
open class BaseTableViewCell: UITableViewCell {
    /// The surface color of the cell.
    ///
    /// This property is overridden to provide a default `.surfaceDefault` background color.
    ///
    /// - Note: Setting a new background color will update the appearance of the cell.
    open var surfaceColor: NeoColor = .neo(.surface, color: .default) {
        didSet {
            super.backgroundColor = surfaceColor.value
        }
    }
    
    /// Performs initial setup for the cell.
    open func setupOnInit() {
        backgroundColor = surfaceColor.value
    }
    
    /// Performs setup when the cell is moved to a superview.
    open func setupOnMovedToSuperview() { }
    
    /// Initializes the cell with a style and a reuse identifier.
    ///
    /// Automatically call setupOnInit on post init.
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupOnInit()
    }
    
    /// Notifies the cell that it has been moved to a new superview.
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupOnMovedToSuperview()
    }
    
    /// Initializes the cell from data in a given unarchiver.
    ///
    /// - Parameter coder: An archiver object.
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        selectionStyle = .none
        setupOnInit()
    }
}
