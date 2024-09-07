//
//  UITableViewCell+Extension.swift
//  Base
//
//  Created by Ghani's Mac Mini on 06/09/2024.
//

import UIKit

public extension UITableViewCell {
    /// The identifier string for the UITableViewCell.
    static var identifier: String {
        String(describing: self)
    }
    
    /// Invokes the selection action for the UITableViewCell.
    ///
    /// This method triggers the selection action for the cell, simulating the behavior as if the cell were selected by user interaction.
    func invokeSelection() {
        if let tableView = superview as? UITableView, let indexPath = tableView.indexPath(for: self) {
            tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
        }
    }
}
