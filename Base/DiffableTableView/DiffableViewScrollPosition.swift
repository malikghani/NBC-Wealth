//
//  DiffableViewScrollPosition.swift
//  Base
//
//  Created by Ghani's Mac Mini on 05/09/2024.
//

import UIKit

/// Enum representing the scroll position within a diffable view.
public enum DiffableViewScrollPosition {
    /// Indicates the scroll view is at the top.
    case top
    
    /// Indicates the scroll view is scrolling at a specific position.
    ///
    /// - Parameter CGPoint: The current content offset of the scroll view.
    case scrollingAt(CGPoint)
    
    /// Indicates the scroll view is at the bottom.
    case bottom
    
    /// Initializes the scroll position based on the content offset and size of the given scroll view.
    ///
    /// - Parameter scrollView: The UIScrollView whose scroll position is to be determined.
    public init(inside scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        
        switch scrollView.contentOffset.y {
        case _ where scrollView.contentSize.height < scrollView.frame.height:
            self = .top
        case ...0:
            self = .top
        case bottomEdge where bottomEdge >= scrollView.contentSize.height:
            self = .bottom
        default:
            self = .scrollingAt(scrollView.contentOffset)
        }
    }
}

// MARK: - Public Functionality
public extension DiffableViewScrollPosition {
    // A computed property that checks if the scroll position is at the top.
    var isOnTop: Bool {
        if case .top = self {
            return true
        }
        
        return false
    }
    
    var offset: CGPoint {
        switch self {
        case .top:
            .zero
        case .scrollingAt(let point):
            point
        case .bottom:
            .zero
        }
    }
}
