//
//  AttributedStringProducer+KeyValue.swift
//  Base
//
//  Created by Ghani's Mac Mini on 07/09/2024.
//

import UIKit
import NeoBase

public extension AttributedStringProducer {
    /// Represents key-value pairs for configuring attributes in an attributed string.
    enum AttributedKeyValue {
        // General
        case backgroundColor(NeoColor<Surface>)
        case foregroundColor(NeoColor<Text>)
        case font(UIFont)
        case paragraphStyle(NSMutableParagraphStyle)
        
        // Typesettings
        case ligature(Bool)
        case kern(CGFloat)
        case tracking(CGFloat)
        
        // Strikethrough
        /// Only pass the `patternStyle` parameter if needed to apply pattern to the strikethrough
        case strikethroughStyle(NSUnderlineStyle, patternStyle: NSUnderlineStyle? = nil)
        case strikethroughColor(NeoColor<Border>)
        
        // Underline
        // Only pass the `patternStyle` parameter if needed to apply pattern to the underline
        case underlineStyle(NSUnderlineStyle, patternStyle: NSUnderlineStyle? = nil)
        case underlineColor(NeoColor<Border>)
        
        // Stroke
        case strokeColor(NeoColor<Border>)
        case strokeWidth(CGFloat, fill: Bool = true)
        
        // Shadow
        case shadow(offset: CGSize = .zero, radius: CGFloat = 1, color: NeoColor<Surface>)
        
        /// The key associated with the attribute.
        var key: NSAttributedString.Key {
            switch self {
                
            // General
            case .backgroundColor:
                return .backgroundColor
            case .foregroundColor:
                return .foregroundColor
            case .font:
                return .font
            case .paragraphStyle:
                return .paragraphStyle
            
            // Typesettings
            case .ligature:
                return .ligature
            case .kern:
                return .kern
            case .tracking:
                if #available(iOS 14.0, *) {
                    return .tracking
                }
                
                return .kern
                
            // Strikethrough
            case .strikethroughStyle:
                return .strikethroughStyle
            case .strikethroughColor:
                return .strikethroughColor
                
            // Underline
            case .underlineStyle:
                return .underlineStyle
            case .underlineColor:
                return .underlineColor
                
            // Stroke
            case .strokeColor:
                return .strokeColor
            case .strokeWidth:
                return .strokeWidth
                
            // Shadow
            case .shadow:
                return .shadow
            }
        }
        
        /// The value associated with the attribute.
        var value: Any {
            switch self {
                
            // General
            case .backgroundColor(let color):
                return color.value
            case .foregroundColor(let color):
                return color.value
            case .font(let font):
                return font
            case .paragraphStyle(let style):
                return style
                
            // Typesettings
            case .ligature(let useLigature):
                return useLigature ? 1 : 0
            case .kern(let kern):
                return kern
            case .tracking(let tracking):
                return tracking
                
            // Strikethrough & underline
            case .strikethroughColor(let color),
                 .underlineColor(let color):
                return color
            case .strikethroughStyle(let style, let patternStyle),
                 .underlineStyle(let style, let patternStyle):
                if let patternStyle {
                    return style.rawValue | patternStyle.rawValue
                }
                
                return style.rawValue
                
            // Stroke
            case .strokeColor(let color):
                return color
            case .strokeWidth(let width, let fill):
                return fill ? -width : width
                
            // Shadow
            case .shadow(let offset, let radius, let color):
                let shadow = NSShadow()
                shadow.shadowOffset = offset
                shadow.shadowBlurRadius = radius
                shadow.shadowColor = color
                
                return shadow
            }
        }
    }
}
