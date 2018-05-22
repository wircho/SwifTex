//
//  TikzStyle.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-16.
//  Copyright © 2018 Wircho. All rights reserved.
//

import AppKit

public enum TikzModifier: String {
    case dashed
    case dotted
}

public struct TikzStyle {
    public var lineWidth: LengthProtocol?
    public var modifier: TikzModifier?
    public var lineColor: NSColor?
    public var fillColor: NSColor?
    
    public init(_ lineWidth: LengthProtocol? = nil, _ modifier: TikzModifier? = nil, line lineColor: NSColor? = nil, fill fillColor: NSColor? = nil) {
        self.lineWidth = lineWidth
        self.lineColor = lineColor
        self.fillColor = fillColor
        self.modifier = modifier
    }
}

public extension TikzStyle {
    public static let none = TikzStyle()
}

private extension NSColor {
    var tuple: (red: Float, green: Float, blue: Float) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (Float(red), Float(green), Float(blue))
    }
    
    var tupleString: String {
        let tuple = self.tuple
        return "\(tuple.red), \(tuple.green), \(tuple.blue)"
    }
}

private let fillColorName = "fill_color"
private let lineColorName = "draw_color"
public extension TikzStyle {
    private var colorsDescription: String {
        return [fillColor.map{ "\\definecolor{\(fillColorName)}{rgb}{\($0.tupleString)}" }, lineColor.map{ "\\definecolor{\(lineColorName)}{rgb}{\($0.tupleString)}" }].compactMap{ $0.map{ $0 + "\n" } }.joined(separator: "")
    }
    
    private var paramsDescription: String {
        let params = [lineWidth.map { "line width = \($0)" }, fillColor.map { _ in "fill = \(fillColorName)" }, lineColor.map { _ in "draw = \(lineColorName)" }, modifier.map { $0.rawValue }].compactMap{ $0 }
        return params.count == 0 ? "" : "[" + params.joined(separator: ", ") + "]"
    }
    
    public var drawPrefix: String {
        return colorsDescription + "\\draw" + paramsDescription
    }
}
