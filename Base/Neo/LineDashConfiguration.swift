//
//  LineDashConfiguration.swift
//  Base
//
//  Created by Ghani's Mac Mini on 07/09/2024.
//

import UIKit

/// A configuration struct for specifying settings related to dashed lines.
public struct LineDashConfiguration {
    /// The line cap style to be used for the dashed line.
    public var lineCap: CAShapeLayerLineCap
    
    /// The dash pattern array specifying the lengths of dashes and gaps.
    public var pattern: [NSNumber]
    
    /// The color of the line.
    public var color: UIColor

    /// The width or thickness of the line.
    public var width: CGFloat

    /// Initializes a `LineConfiguration` with optional parameters.
    ///
    /// - Parameters:
    ///   - color: The color of the line or border.
    ///   - width: The width or thickness of the line or border. Default is `1`.
    ///   - lineCap: The line cap style to be used for the dashed line. Default is `.butt`.
    ///   - pattern: The dash pattern array specifying the lengths of dashes and gaps. Default is `[5, 5]`.
    public init(color: UIColor,
                width: CGFloat = 1,
                lineCap: CAShapeLayerLineCap = .butt,
                pattern: [NSNumber] = [5, 5]) {
        self.color = color
        self.width = width
        self.lineCap = lineCap
        self.pattern = pattern
    }
}
