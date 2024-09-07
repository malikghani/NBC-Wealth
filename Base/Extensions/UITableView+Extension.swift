//
//  UITableView+Extension.swift
//  Base
//
//  Created by Ghani's Mac Mini on 06/09/2024.
//

import UIKit

/// Shorthand for Cell Customization Block
public typealias CustomizationCell<T> = ((T) -> Void)

public extension UITableView {
    /// Registers a list of UITableViewCells to the TableView.
    ///
    /// Automatically registers them using their identifiers.
    /// - Parameter cells: UITableViewCells that need to be registered to the TableView.
    func register(_ cells: UITableViewCell.Type...) {
        cells.forEach { cell in
            register(cell, forCellReuseIdentifier: cell.identifier)
        }
    }
    
    /// Dequeues a UITableViewCell in the TableView.
    ///
    /// - Parameters:
    ///   - cell: The cell to be dequeued.
    ///   - indexPath: The IndexPath for dequeuing the cell.
    ///   - customization: Any customization that needs to be made for the dequeued cell.
    ///   - Returns: A cell, either the given cell or a UITableViewCell if the casting to the given cell fails.
    func dequeue<T: UITableViewCell>(
        _ cell: T.Type,
        for indexPath: IndexPath,
        customization: CustomizationCell<T>? = nil
    ) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            return UITableViewCell()
        }
        
        customization?(cell)
        return cell
    }
    
    /// Dequeues a UITableViewCell in the TableView.
    ///
    /// It's constrained to cells that conform to the `ViewModelProviding` protocol, indicating that the cell has a view model.
    ///
    /// - Parameters:
    ///   - cell: The cell to be dequeued.
    ///   - indexPath: The IndexPath for dequeuing the cell.
    ///   - viewModel: The viewModel to be passed to the given cell.
    ///   - customization: Any customization that needs to be made for the dequeued cell.
    ///   - Returns: A cell, either the given cell or a UITableViewCell if the casting to the given cell fails.
    func dequeue<T: UITableViewCell & ViewModelProviding>(
        _ cell: T.Type,
        for indexPath: IndexPath,
        with viewModel: T.ViewModel,
        customization: CustomizationCell<T>? = nil
    ) -> UITableViewCell {
        guard var cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            return UITableViewCell()
        }
        
        cell.viewModel = viewModel
        customization?(cell)
        return cell
    }
    
    /// Dequeues a UITableViewCell in the TableView.
    ///
    /// It's constrained to cells that conform to the `DelegateProviding` protocol, indicating that the cell has a delegate property.
    ///
    /// - Parameters:
    ///   - cell: The cell to be dequeued.
    ///   - indexPath: The IndexPath for dequeuing the cell.
    ///   - delegate: The delegate for the cell.
    ///   - customization: Any customization that needs to be made for the dequeued cell.
    ///   - Returns: A cell, either the given cell or a UITableViewCell if the casting to the given cell fails.
    func dequeue<T: UITableViewCell & DelegateProviding>(
        _ cell: T.Type,
        for indexPath: IndexPath,
        delegate: T.Delegate,
        customization: CustomizationCell<T>? = nil
    ) -> UITableViewCell {
        guard var cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            return UITableViewCell()
        }
        
        cell.delegate = delegate
        customization?(cell)
        return cell
    }
    
    /// Dequeues a UITableViewCell in the TableView.
    ///
    /// It's constrained to cells that conform to the `ViewModelProviding` and `DelegateProviding` protocol,
    /// indicating that the cell has a view model and delegate property.
    ///
    /// - Parameters:
    ///   - cell: The cell to be dequeued.
    ///   - indexPath: The IndexPath for dequeuing the cell.
    ///   - delegate: The delegate for the cell.
    ///   - viewModel: The viewModel to be passed to the given cell.
    ///   - customization: Any customization that needs to be made for the dequeued cell.
    ///   - Returns: A cell, either the given cell or a UITableViewCell if the casting to the given cell fails.
    func dequeue<T: UITableViewCell & ViewModelProviding & DelegateProviding>(
        _ cell: T.Type,
        for indexPath: IndexPath,
        with viewModel: T.ViewModel,
        delegate: T.Delegate,
        customization: CustomizationCell<T>? = nil
    ) -> UITableViewCell {
        guard var cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            return UITableViewCell()
        }
        
        cell.delegate = delegate
        cell.viewModel = viewModel
        customization?(cell)
        return cell
    }
}
