//
//  TikzItem.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-17.
//  Copyright © 2018 Wircho. All rights reserved.
//

import AppKit

public protocol TikzItem: CustomStringConvertible {
    var start: TikzPoint.Raw { get }
    var headers: [String] { get }
}

public struct AnyTikzItem {
    fileprivate let getDescription: () -> String
    fileprivate let getHeaders: () -> [String]
    public init<T: TikzItem>(_ item: T) {
        getDescription = { item.description }
        getHeaders = { item.headers }
    }
}

extension AnyTikzItem: CustomStringConvertible {
    public var description: String { return getDescription() }
    public var headers: [String] { return getHeaders() }
}

extension AnyTikzItem: TikzElement {
    public var elementCode: String { return TikzPath(self).elementCode }
}

public extension AnyTikzItem {
    public static func point(_ x: LengthProtocol, _ y: LengthProtocol) -> AnyTikzItem {
        return AnyTikzItem(TikzPoint(x, y))
    }
    public static func circle(_ center: TikzPoint.Raw, _ radius: LengthProtocol) -> AnyTikzItem {
        return AnyTikzItem(TikzCircle(center, radius))
    }
    public static func ellipse(_ center: TikzPoint.Raw, _ radius0: LengthProtocol, _ radius1: LengthProtocol) -> AnyTikzItem {
        return AnyTikzItem(TikzEllipse(center, radius0, radius1))
    }
    public static func arc(_ start: TikzPoint.Raw, _ angle0: Float, _ angle1: Float, _ radius: LengthProtocol) -> AnyTikzItem {
        return AnyTikzItem(TikzArc(start, angle0, angle1, radius))
    }
    public static func curve(_ start: TikzPoint.Raw, _ control0: TikzPoint.Raw, _ control1: TikzPoint.Raw, _ end: TikzPoint.Raw) -> AnyTikzItem {
        return AnyTikzItem(TikzCurve(start, control0, control1, end))
    }
    public static func node(_ start: TikzPoint.Raw, anchor: TikzNode.Anchor? = nil, _ text: String) -> AnyTikzItem {
        return AnyTikzItem(TikzNode(start, anchor: anchor, text))
    }
    public static func node(_ start: TikzPoint.Raw, _ shape: TikzNode.Style.Shape, line lineColor: NSColor? = nil, fill fillColor: NSColor? = nil, anchor: TikzNode.Anchor? = nil, _ text: String) -> AnyTikzItem {
        return AnyTikzItem(TikzNode(start, shape, line: lineColor, fill: fillColor, anchor: anchor, text))
    }
    public static func node(_ start: TikzPoint.Raw, anchor: TikzNode.Anchor? = nil, _ math: Math) -> AnyTikzItem {
        return .node(start, anchor: anchor, "\(math)")
    }
    public static func node(_ start: TikzPoint.Raw, _ shape: TikzNode.Style.Shape, line lineColor: NSColor? = nil, fill fillColor: NSColor? = nil, anchor: TikzNode.Anchor? = nil, _ math: Math) -> AnyTikzItem {
        return .node(start, shape, line: lineColor, fill: fillColor, anchor: anchor, "\(math)")
    }
}

public extension AnyTikzItem {
    public init(_ rawPoint: TikzPoint.Raw) {
        self.init(TikzPoint(rawPoint.0, rawPoint.1))
    }
}
