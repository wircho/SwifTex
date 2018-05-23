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

private var colorCounter = 0
internal struct ColorNamer {
    let line: String
    let fill: String
    init() {
        line = "line_\(colorCounter)"
        fill = "fill_\(colorCounter)"
        colorCounter += 1
    }
}

public struct TikzStyle {
    public var lineWidth: LengthProtocol?
    public var modifier: TikzModifier?
    public var lineColor: NSColor?
    public var fillColor: NSColor?
    public var extraHeaders: [String] = []
    internal let colorNamer = ColorNamer()
    
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

internal extension NSColor {
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

extension TikzStyle: TikzColorful {
    private func headers(for path: TikzPath) -> String {
        var headers = self.colorHeaders
        for item in path.items { headers += item.headers }
        return headers.map{ $0 + "\n" }.joined(separator: "")
    }
    
    private var paramsDescription: String {
        let params = ([lineWidth.map { "line width = \($0)" }] + colorDescriptions as [String?]  + [modifier.map { $0.rawValue }]).compactMap{ $0 }
        return params.count == 0 ? "" : "[" + params.joined(separator: ", ") + "]"
    }
    
    public func drawPrefix(for path: TikzPath) -> String {
        return headers(for: path) + "\\draw" + paramsDescription
    }
}
