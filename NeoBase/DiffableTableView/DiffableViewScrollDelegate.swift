//
//  DiffableViewScrollDelegate.swift
//  Base
//
//  Created by Ghani's Mac Mini on 05/09/2024.
//

import Foundation

/// A protocol to handle scroll events for a diffable view (DiffableTableView & DiffableCollectionView).
public protocol DiffableViewScrollDelegate: AnyObject {
    /// The type of the Section in Diffable Data Source
    associatedtype Section: Hashable, Sendable
    
    /// Called when the diffable view scrolls.
    ///
    /// - Parameter position: The current scroll position of the diffable view.
    func diffableViewDidScroll(to position: DiffableViewScrollPosition, at section: Section?)
}

// MARK: - DiffableViewScrollDelegate Default Implementation
extension DiffableViewScrollDelegate {
    /// Default implementation does nothing. Implement this method to handle scroll events.
    func diffableViewDidScroll(to position: DiffableViewScrollPosition, at section: Section?) { }
}
