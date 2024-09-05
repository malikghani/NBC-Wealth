//
//  DiffableTableViewProvider.swift
//  Base
//
//  Created by Ghani's Mac Mini on 05/09/2024.
//

import UIKit

/// A protocol for providing data and behavior to a `DiffableTableView`.
///
/// - SeeAlso: [**Confluence:** DiffableTableView Documentation](https://graveltechnologies.atlassian.net/l/cp/Zz3kuWuQ)
public protocol DiffableTableViewDataProvider: AnyObject {
    /// The type of the Section in Diffable Data Source
    associatedtype Section: Hashable, Sendable
    
    /// The type of the Item in Diffable Data Source
    associatedtype Item: Hashable, Sendable
    
    /// Provides a UITableViewCell for a given section and item at a specified indexPath.
    ///
    /// - Parameters:
    ///   - section: The section for which to provide a cell.
    ///   - item: The item for which to provide a cell.
    ///   - indexPath: The indexPath of the item in the table view.
    /// - Returns: A configured UITableViewCell for the specified item, or `nil` if no cell is provided.
    func provideCell(for section: Section, in item: Item, at indexPath: IndexPath) -> UITableViewCell?

    /// Handles the tap gesture on a row within a specific section.
    ///
    /// The default implementation does nothing on row tap if not provided by the conforming type.
    ///
    /// - Parameters:
    ///   - section: The section of the tapped row.
    ///   - item: The item within the tapped row (may be `nil`).
    func handleRowTap(in section: Section, at item: Item?)

    /// Sets the row height for a specific item within a section.
    ///
    /// If not provided by the conforming type, the default implementation returns `UITableView.automaticDimension`.
    ///
    /// - Parameters:
    ///   - section: The section of the row.
    ///   - item: The item within the row (may be `nil`).
    /// - Returns: The desired height for the row.
    func setRowHeight(in section: Section, at item: Item?) -> CGFloat

    /// Sets the header view for a specific section.
    ///
    /// If not provided by the conforming type, the default implementation returns `nil`.
    ///
    /// - Parameter section: The section for which to set the header view.
    /// - Returns: The configured header view for the specified section, or `nil` if no header view is provided.
    func setHeaderView(in section: Section) -> UIView?

    /// Sets the height for the header view in a specific section.
    ///
    /// If not provided by the conforming type, the default implementation returns `.zero` if it doesn't have a header; otherwise, it returns `UITableView.automaticDimension`.
    ///
    /// - Parameter section: The section for which to set the header view height.
    /// - Returns: The desired height for the header view.
    func setHeaderViewHeight(in section: Section) -> CGFloat

    /// Sets the footer view for a specific section.
    ///
    /// If not provided by the conforming type, the default implementation returns `nil`.
    ///
    /// - Parameter section: The section for which to set the footer view.
    /// - Returns: The configured footer view for the specified section, or `nil` if no footer view is provided.
    func setFooterView(in section: Section) -> UIView?

    /// Sets the height for the footer view in a specific section.
    ///
    /// If not provided by the conforming type, the default implementation returns `.zero` if it doesn't have a footer; otherwise, it returns `UITableView.automaticDimension`.
    ///
    /// - Parameter section: The section for which to set the footer view height.
    /// - Returns: The desired height for the footer view.
    func setFooterViewHeight(in section: Section) -> CGFloat
    
    /// Sets the estimated row height for a given section and item in the table view.
    ///
    /// If not provided by the conforming type, the default implementation returns `UITableView.automaticDimension`.
    ///
    /// - Parameters:
    ///   - section: The section index in the table view.
    ///   - item: The item index within the section, or `nil` if the height is not specific to an item.
    /// - Returns: The estimated row height for the specified section and item.
    func setEstimatedRowHeight(in section: Section, at item: Item?) -> CGFloat

    /// Sets the estimated header height for a given section in the table view.
    ///
    /// If not provided by the conforming type, the default implementation returns `UITableView.automaticDimension`.
    ///
    /// - Parameter section: The section index in the table view.
    /// - Returns: The estimated header height for the specified section.
    func setEstimatedHeaderHeight(in section: Section) -> CGFloat

    /// Sets the estimated footer height for a given section in the table view.
    ///
    /// If not provided by the conforming type, the default implementation returns `UITableView.automaticDimension`.
    ///
    /// - Parameter section: The section index in the table view.
    /// - Returns: The estimated footer height for the specified section.
    func setEstimatedFooterHeight(in section: Section) -> CGFloat
    
    /// Handles the long press gesture on a row within a specific section.
    ///
    /// The default implementation does nothing on long press if not provided by the conforming type.
    ///
    /// - Parameters:
    ///   - section: The section of the long-pressed row.
    ///   - item: The item within the long-pressed row (may be `nil`).
    func handleLongPress(in section: Section, at item: Item?)
    
    /// Called when a header view is no longer being displayed in the specified section.
    ///
    /// - Parameters:
    ///   - section: The section in which the header view was displayed.
    ///   - view: The header view that was displayed.
    func didEndDisplayingHeader(in section: Section, for view: UIView)
    
    /// Called when a cell is no longer being displayed in the specified section.
    ///
    /// - Parameters:
    ///   - section: The section in which the cell was displayed.
    ///   - item: The item that the cell was displaying.
    ///   - cell: The cell that was displayed.
    func didEndDisplaying(in section: Section, at item: Item?, for cell: UITableViewCell)
    
    /// Called when a footer view is no longer being displayed in the specified section.
    ///
    /// - Parameters:
    ///   - section: The section in which the footer view was displayed.
    ///   - view: The footer view that was displayed.
    func didEndDisplayingFooter(in section: Section, for view: UIView)
    
    /// Called when a cell is about to be displayed.
    ///
    /// - Parameters:
    /// - section: The section of the long-pressed row.
    /// - item: The item within the long-pressed row (may be `nil`).
    /// - indexPath: The indexPath of the item in the table view.
    func willDisplay(in section: Section, at item: Item?, at indexPath: IndexPath)
    
    /// The type of haptic feedback to produce when a row is tapped.
    ///
    /// If not provided by the conforming type, the default implementation returns `nil`.
    var hapticTypeOnRowTap: HapticProducer.FeedbackType? { get }
    
    /// The type of haptic feedback to produce when a row is long pressed.
    ///
    /// If not provided by the conforming type, the default implementation returns `nil`.
    var hapticTypeOnRowLongPress: HapticProducer.FeedbackType? { get }
}

// MARK: - DiffableTableViewDataProvider Default Implementations
public extension DiffableTableViewDataProvider {
    func handleRowTap(in section: Section, at item: Item?) { }
    
    func setRowHeight(in section: Section, at item: Item?) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func setHeaderView(in section: Section) -> UIView? {
        nil
    }
    
    func setHeaderViewHeight(in section: Section) -> CGFloat {
        setHeaderView(in: section) == nil ? .zero : UITableView.automaticDimension
    }
    
    func setFooterView(in section: Section) -> UIView? {
        nil
    }
    
    func setFooterViewHeight(in section: Section) -> CGFloat {
        setFooterView(in: section) == nil ? .zero : UITableView.automaticDimension
    }
    
    func setEstimatedRowHeight(in section: Section, at item: Item?) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func setEstimatedHeaderHeight(in section: Section) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func setEstimatedFooterHeight(in section: Section) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func handleLongPress(in section: Section, at item: Item?) { }
    
    func didEndDisplayingHeader(in section: Section, for view: UIView) { }
    
    func didEndDisplaying(in section: Section, at item: Item?, for cell: UITableViewCell) { }
    
    func didEndDisplayingFooter(in section: Section, for view: UIView) { }
    
    func willDisplay(in section: Section, at item: Item?, at indexPath: IndexPath) { }
    
    var hapticTypeOnRowTap: HapticProducer.FeedbackType? {
        nil
    }
    
    var hapticTypeOnRowLongPress: HapticProducer.FeedbackType? {
        nil
    }
}
