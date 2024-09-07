//
//  AttributedStringProducer.swift
//  Base
//
//  Created by Ghani's Mac Mini on 07/09/2024.
//

import Foundation

/// A helper struct for creating and customizing attributed strings without typing the same code repeatedly.
public struct AttributedStringProducer {
    /// The source text used to create the attributed string.
    ///
    /// This property is set to static so that we can use its value as the default `text` parameter value for the `assign` method.
    public var sourceText: String = ""
        
    /// The mutable attributed string being managed.
    private var attributedString: NSMutableAttributedString
        
    /// Initializes an instance of the struct using a `StringConvertible`.
    ///
    /// - Parameter convertible: An object conforming to `StringConvertible` providing text and an optional attributed string.
    ///
    /// Use this initializer to create an `AttributedStringProducer` instance with the specified source text.
    /// The attributed string is automatically generated from the convertible itself.
    public init(from text: String) {
        sourceText = text
        attributedString = .init(string: text)
    }
}

// MARK: - Public Functionality
public extension AttributedStringProducer {
    /// Assigns the specified attribute to the given text within the attributed string.
    ///
    /// - Parameters:
    ///   - attribute: The `AttributedKeyValue` instance specifying the attribute to be applied.
    ///   - text: The text to which the attribute should be applied. The default is nil, in which case the source text, representing the entire content, will be used.
    ///   - recursive: If `true`, applies the attribute to all occurrences of the text. Default is `false`.
    ///   - caseSensitive: If set to `false`, the text we want to assign the attribute and the sourceText will be treated without case sensitivity. Default is `true`.
    /// - Returns: The modified `AttributedStringManager` instance with the assigned attribute.
    @discardableResult
    func assign(_ attribute: AttributedKeyValue, for text: String? = nil, recursive: Bool = false, caseSensitive: Bool = true) -> Self {
        let text = text ?? sourceText
        
        if recursive {
            return assignRecursiveRanges(attribute, for: text, caseSensitive: caseSensitive)
        }

        return assignSingleRange(attribute, for: text, caseSensitive: caseSensitive)
    }
    
    /// Retrieves the managed attributed string.
    ///
    /// - Returns: The `NSMutableAttributedString` managed by this instance.
    func get() -> NSMutableAttributedString {
        attributedString
    }
}

// MARK: - Ranges Functionality
private extension AttributedStringProducer {
    /// Retrieves an array of `NSRange` instances representing the ranges of occurrences of the specified substring in the attributed string.
    ///
    /// - Parameters:
    ///   - substring: The substring to search for.
    ///   - caseSensitive: The ranges of the text we want to get will be treated with case sensitivity or not.
    /// - Returns: An array of `NSRange` instances representing the ranges where the substring is found.
    func getRanges(of substring: String, caseSensitive: Bool) -> [NSRange] {
        var ranges: [NSRange] = []
        let fullRange = NSRange(location: 0, length: attributedString.length)
        
        var searchRange = fullRange
        while let range = attributedString.string.range(of: substring, options: caseSensitive ? [] : .caseInsensitive, range: Range(searchRange, in: attributedString.string)) {
            let nsRange = NSRange(range, in: attributedString.string)
            ranges.append(nsRange)
            searchRange = NSRange(location: nsRange.upperBound, length: fullRange.upperBound - nsRange.upperBound)
        }
        
        return ranges
    }

    /// Retrieves the range of the specified text within the source text.
    ///
    /// - Parameters:
    ///   - text: The text to search for.
    ///   - caseSensitive: The range of the text we want to get will be treated with case sensitivity or not.
    /// - Returns: An `NSRange` instance representing the range where the text is found.
    func getRange(of text: String, caseSensitive: Bool) -> NSRange {
        if caseSensitive {
            return (sourceText as NSString).range(of: text)
        }
        
        return (sourceText.lowercased() as NSString).range(of: text.lowercased())
    }
}

// MARK: - Attribute Assignments
private extension AttributedStringProducer {
    /// Assigns the specified attribute to a single occurrence of the given text within the attributed string.
    ///
    /// - Parameters:
    ///   - attribute: The `AttributedKeyValue` instance specifying the attribute to be applied.
    ///   - text: The text to which the attribute should be applied.
    ///   - caseSensitive: The text we want to assign the attribute and the sourceText will be treated with case sensitivity or not.
    /// - Returns: The modified `AttributedStringManager` instance with the assigned attribute.
    @discardableResult
    func assignSingleRange(_ attribute: AttributedKeyValue, for text: String, caseSensitive: Bool) -> Self {
        let range = getRange(of: text, caseSensitive: caseSensitive)
        attributedString.addAttribute(attribute.key, value: attribute.value, range: range)
        
        return self
    }

    /// Assigns the specified attribute to all occurrences of the given text within the attributed string.
    ///
    /// - Parameters:
    ///   - attribute: The `AttributedKeyValue` instance specifying the attribute to be applied.
    ///   - text: The text to which the attribute should be applied.
    ///   - caseSensitive: The text we want to assign the attribute and the sourceText will be treated with case sensitivity or not.
    /// - Returns: The modified `AttributedStringManager` instance with the assigned attribute.
    @discardableResult
    func assignRecursiveRanges(_ attribute: AttributedKeyValue, for text: String, caseSensitive: Bool) -> Self {
        getRanges(of: text, caseSensitive: caseSensitive).forEach {
            attributedString.addAttribute(attribute.key, value: attribute.value, range: $0)
        }

        return self
    }
}
