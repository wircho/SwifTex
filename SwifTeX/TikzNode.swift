//
//  TikzNode.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-22.
//  Copyright © 2018 Wircho. All rights reserved.
//

import AppKit

public struct TikzNode {
    public enum Anchor: String {
        case north
        case south
        case east
        case west
        case northEast = "north east"
        case northWest = "north west"
        case southEast = "south east"
        case southWest = "south west"
    }
    
    public struct Style: TikzColorful {
        public enum Shape: String {
            case rectangle
            case circle
        }
        
        public let shape: Shape?
        public let lineColor: NSColor?
        public let fillColor: NSColor?
        
        internal let colorNamer = ColorNamer()
        
        public init(_ shape: Shape? = nil, line lineColor: NSColor? = nil, fill fillColor: NSColor? = nil) {
            self.shape = shape
            self.lineColor = lineColor
            self.fillColor = fillColor
        }
        
        public static let none = Style()
        
        fileprivate var colorsDescription: String {
            return [fillColor.map{ "\\definecolor{\(colorNamer.fill)}{rgb}{\($0.tupleString)}" }, lineColor.map{ "\\definecolor{\(colorNamer.line)}{rgb}{\($0.tupleString)}" }].compactMap{ $0.map{ $0 + "\n" } }.joined(separator: "")
        }
    }
    
    public let start: TikzPoint.Raw
    public let style: Style
    public let anchor: Anchor?
    public let text: String
    
    public init(_ start: TikzPoint.Raw, anchor: Anchor? = nil, _ text: String) {
        self.start = start
        self.style = .none
        self.anchor = anchor
        self.text = text
    }
    
    public init(_ start: TikzPoint.Raw, _ shape: Style.Shape, line lineColor: NSColor? = nil, fill fillColor: NSColor? = nil, anchor: Anchor? = nil, _ text: String) {
        self.start = start
        self.style = Style(shape, line: lineColor, fill: fillColor)
        self.anchor = anchor
        self.text = text
    }
}

extension TikzNode: TikzItem {
    public var description: String {
        let anchorDescription = anchor.map{ ["anchor = " + $0.rawValue] } ?? []
        var styleDescription = style.colorDescriptions
        if let shape = style.shape {
            if (styleDescription.count == 0) { styleDescription.append("draw") }
            styleDescription.insert(shape.rawValue, at: 0)
        }
        styleDescription += anchorDescription
        let bracket = styleDescription.count == 0 ? "" : "[\(styleDescription.joined(separator: ", "))]"
        return "(\(start.0),\(start.1)) node\(bracket){\(escape(text))}"
    }
    
    public var headers: [String] {
        return style.colorHeaders
    }
}
