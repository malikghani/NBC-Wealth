//
//  VerticalStackView.swift
//  Base
//
//  Created by Ghani's Mac Mini on 07/09/2024.
//

import UIKit

/// Custom UIStackView subclass configured for vertical stacking.
public final class VerticalStackView: UIStackView {
    /// Initializes a vertical stack view with the specified frame.
    ///
    /// - Parameter frame: The frame rectangle for the stack view.
    public override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
