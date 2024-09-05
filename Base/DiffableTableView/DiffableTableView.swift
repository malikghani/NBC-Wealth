//
//  DiffableTableView.swift
//  Base
//
//  Created by Ghani's Mac Mini on 05/09/2024.
//

import UIKit

/// A TableView class that implements `DiffableDatasource` to reduce complexity and code boilerplate for displaying data lists in the app.
///
/// To use this class, controller must conforms to `DiffableTableViewDataProvider` protocol, serving as the data and behavior provider for the table view.
///
/// - SeeAlso: [**Confluence:** DiffableTableView Documentation](https://graveltechnologies.atlassian.net/l/cp/Zz3kuWuQ)
public final class DiffableTableView<Provider: DiffableTableViewDataProvider>: UITableView, UITableViewDelegate {
    /// Acts as the data and behavior provider for the table view.
    ///
    /// Data and behavior provider for the table view, supplying implementations for cell, header, footer, and press actions.
    private weak var provider: Provider?
    
    /// The scroll delegate for this table view.
    private weak var scrollDelegate: DiffableViewScrollDelegate?

    /// Shorthand for the Data Source Snapshot
    public typealias Snapshot = NSDiffableDataSourceSnapshot<Provider.Section, Provider.Item>
    
    /// Shorthand for the Diffable Data Source
    public typealias Datasource = UITableViewDiffableDataSource<Provider.Section, Provider.Item>
    
    /// Acts as a data source for this table view.
    /// No need to worry about force unwrapping since it will always be assigned in the initializer.
    private var source: Datasource!
    
    /// Begin of TableViewDelegate Protocol Conformance
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let feedbackType = provider?.hapticTypeOnRowTap {
            HapticProducer.shared.perform(feedback: feedbackType)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        provider?.handleRowTap(in: getSection(at: indexPath.section), at: getItem(at: indexPath))
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        provider?.setRowHeight(in: getSection(at: indexPath.section), at: getItem(at: indexPath)) ?? .zero
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        provider?.setHeaderView(in: getSection(at: section))
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        provider?.setHeaderViewHeight(in: getSection(at: section)) ?? .zero
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        provider?.setFooterView(in: getSection(at: section))
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        provider?.setFooterViewHeight(in: getSection(at: section)) ?? .zero
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        provider?.setEstimatedRowHeight(in: getSection(at: indexPath.section), at: getItem(at: indexPath)) ?? UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        provider?.setEstimatedHeaderHeight(in: getSection(at: section)) ?? UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        provider?.setEstimatedFooterHeight(in: getSection(at: section)) ?? UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        guard section < tableView.numberOfSections else {
            return
        }
        
        provider?.didEndDisplayingHeader(in: getSection(at: section), for: view)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.section < tableView.numberOfSections,
              indexPath.row < tableView.numberOfRows(inSection: indexPath.section) else {
            return
        }
        
        provider?.didEndDisplaying(in: getSection(at: indexPath.section), at: getItem(at: indexPath), for: cell)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        guard section < tableView.numberOfSections else {
            return
        }
        
        provider?.didEndDisplayingFooter(in: getSection(at: section), for: view)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        provider?.willDisplay(in: getSection(at: indexPath.section), at: getItem(at: indexPath), at: indexPath)
    }
    /// End of TableViewDelegate Conformance
    
    /// Begin of UIScrollViewDelegate Protocol Conformance
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = DiffableViewScrollPosition(inside: scrollView)
        scrollDelegate?.diffableViewDidScroll(to: position)
    }
    /// End of UIScrollViewDelegate Protocol Conformance
    
    /// Initializes a data source for a DiffableTableView.
    ///
    /// - Parameters:
    ///   - style: The style of the UITableView. Default is `.plain`.
    ///   - backgroundColor: The color for the TableView. Default is `.Background_Default`.
    ///   - rowAnimation: The animation style when rows are inserted or deleted. Default is `.fade`.
    ///   - provider: A generic type conforming to the DiffableTableViewDataProvider protocol, serving as a data and behavior provider.
    ///
    ///   - Example usage:
    /// ```
    ///     private lazy var tableView: DiffableTableView<PaymentMethodViewController> = {
    ///         let tableView = DiffableTableView(style: .grouped, provider: self).with(parent: view)
    ///         tableView.register(PaymentCreditCardSelectionCell.self)
    ///
    ///         return tableView
    ///     }()
    /// ```
    public init(
        style: UITableView.Style = .grouped,
        backgroundColor: UIColor = .white,
        rowAnimation: RowAnimation = .fade,
        provider: Provider,
        scrollDelegate: DiffableViewScrollDelegate? = nil
    ) {
        super.init(frame: .zero, style: style)
        self.provider = provider
        source = .init(tableView: self) { [weak self] _, indexPath, itemIdentifier in
            guard let self else {
                return .init()
            }
            
            let section = getSection(at: indexPath.section)
            return self.provider?.provideCell(for: section, in: itemIdentifier, at: indexPath)
        }
        
        source.defaultRowAnimation = rowAnimation
        contentInset = .zero
        separatorStyle = .none
        delegate = self
        dataSource = source
        applyLongPressGesture()
        self.backgroundColor = backgroundColor
        self.scrollDelegate = scrollDelegate
        
        if #available(iOS 15.0, *) {
            sectionHeaderTopPadding = .zero
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Adds a long press gesture recognizer to the table view.
    private func applyLongPressGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        addGestureRecognizer(gesture)
    }
    
    /// Selector invoked when the user performs a long press on the table view.
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        let touchPoint = sender.location(in: self)
        guard sender.state == .began, let indexPath = indexPathForRow(at: touchPoint) else {
            return
        }
        
        if let feedbackType = provider?.hapticTypeOnRowLongPress {
            HapticProducer.shared.perform(feedback: feedbackType)
        }
        
        provider?.handleLongPress(in: getSection(at: indexPath.section), at: getItem(at: indexPath))
    }
}

// MARK: - Public Functionality
public extension DiffableTableView {
    /// Applies a new snapshot to the data source.
    ///
    /// - Parameter snapshot: The new snapshot to be applied to the data source.
    func apply(_ snapshot: Snapshot, animated: Bool = true) {
        source.apply(snapshot, animatingDifferences: window == nil ? false : animated)
    }
    
    /// Retrieves the section for a given index.
    ///
    /// - Parameter index: The index of the section to retrieve.
    /// - Returns: The section for the given index.
    func getSection(at index: Int) -> Provider.Section {
        currentSnapshot.sectionIdentifiers[index]
    }
    
    /// Retrieves the item for given indexPath.
    ///
    /// - Parameter indexPath: The index path for the item.
    /// - Returns: The item for the given index path.
    func getItem(at indexPath: IndexPath) -> Provider.Item? {
        currentSnapshot.itemIdentifiers(inSection: getSection(at: indexPath.section))[safe: indexPath.row]
    }
    
    /// Checks whether the specified section contains any items.
    ///
    /// - Parameter section: The section to check for items.
    /// - Returns: `true` if the section contains items; otherwise, `false`.
    func checkHasItem(in section: Provider.Section) -> Bool {
        currentSnapshot.numberOfItems(inSection: section) != 0
    }
}

// MARK: - Scroll Functionality
public extension DiffableTableView {
    /// Scrolls to a specific item in the table view. If the item is found, it scrolls to the corresponding row.
    /// If the item is not found, it scrolls to the top of the table view.
    ///
    /// - Parameters:
    ///   - item: The item to scroll to.
    ///   - scrollToTopIfMissing: A boolean value indicating whether to scroll to the top of the table view if the item is not found. Defaults to `false`.
    func scroll(to item: Provider.Item, scrollToTopIfMissing: Bool = false) {
        if let id = currentSnapshot.itemIdentifiers.first(where: { $0 == item }), let index = currentSnapshot.indexOfItem(id) {
            scroll(to: .init(row: index, section: .zero))
        } else if scrollToTopIfMissing {
            scroll(to: .init())
        }
    }

    /// Scrolls to a specific section in the table view. If the section is found, it scrolls to the corresponding section's first row.
    /// If the section is not found, it scrolls to the top of the table view.
    ///
    /// - Parameter section: The section to scroll to.
    ///   - scrollToTopIfMissing: A boolean value indicating whether to scroll to the top of the table view if the section is not found. Defaults to `false`.
    func scroll(to section: Provider.Section, scrollToTopIfMissing: Bool = false) {
        if let id = currentSnapshot.sectionIdentifiers.first(where: { $0 == section }), let index = currentSnapshot.indexOfSection(id) {
            scroll(to: .init(row: .zero, section: index))
        } else if scrollToTopIfMissing {
            scroll(to: .init())
        }
    }

    /// Scrolls to a specific index path in the table view with a spring animation.
    ///
    /// - Parameter indexPath: The index path to scroll to.
    func scroll(to indexPath: IndexPath) {
        springAnimation(duration: 1.0, damping: 0.85, velocity: 0.8, animation: { [weak self] in
            self?.scrollToRow(at: indexPath, at: .middle, animated: false)
        })
    }
}

// MARK: - Refresh Control Functionality
public extension DiffableTableView {
    /// Sets up a refresh control with a specified action to be performed when the control is activated.
    ///
    /// - Parameters:
    ///   - control: The type of refresh control to use. Defaults to `UIRefreshControl`.
    ///   - pullAction: A closure to be executed when the refresh control is activated by a pull-to-refresh gesture.
    func setRefreshControl<T: UIRefreshControl>(with control: T.Type = UIRefreshControl.self, pullAction: @escaping () -> Void) {
        refreshControl = T()
        refreshControl?.addAction(for: .valueChanged, pullAction)
    }

    /// Ends the refreshing state of the refresh control, if active.
    func setRefreshControlEndRefresh() {
        refreshControl?.endRefreshing()
    }
}

// MARK: - Computed Properties
public extension DiffableTableView {
    /// The initial snapshot for this table view.
    var initialSnapshot: Snapshot {
        Snapshot()
    }
    
    /// The current snapshot for the data source.
    var currentSnapshot: Snapshot {
        source.snapshot()
    }
    
    /// Checks if the current snapshot has any items.
    var hasItems: Bool {
        currentSnapshot.numberOfItems > 0
    }
}
