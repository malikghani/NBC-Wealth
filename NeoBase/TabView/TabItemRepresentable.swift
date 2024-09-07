//
//  TabItemRepresentable.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 08/09/2024.
//

/// A protocol representing an item that can be displayed in a tab view, requiring a title for each tab.
public protocol TabItemRepresentable: Equatable {
    /// The title of the tab to be displayed in the tab view.
    var title: String { get }
}
