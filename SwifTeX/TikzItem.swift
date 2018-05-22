//
//  TikzItem.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-17.
//  Copyright © 2018 Wircho. All rights reserved.
//

public protocol TikzItem: CustomStringConvertible {
    var start: TikzPoint.Raw { get }
}

public struct AnyTikzItem {
    fileprivate let getDescription: () -> String
    public init<T: TikzItem>(_ item: T) {
        getDescription = { item.description }
    }
}

extension AnyTikzItem: CustomStringConvertible {
    public var description: String { return getDescription() }
}

extension AnyTikzItem: TikzElement {
    public var elementCode: String { return TikzPath(self).elementCode }
}

public extension AnyTikzItem {
    public static func point(_ x: LengthProtocol, _ y: LengthProtocol) -> AnyTikzItem { return AnyTikzItem(TikzPoint(x, y)) }
    public static func circle(_ center: TikzPoint.Raw, _ radius: LengthProtocol) -> AnyTikzItem { return AnyTikzItem(TikzCircle(center, radius)) }
    public static func ellipse(_ center: TikzPoint.Raw, _ radius0: LengthProtocol, _ radius1: LengthProtocol) -> AnyTikzItem { return AnyTikzItem(TikzEllipse(center, radius0, radius1)) }
    public static func arc(_ start: TikzPoint.Raw, _ angle0: Float, _ angle1: Float, _ radius: LengthProtocol) -> AnyTikzItem { return AnyTikzItem(TikzArc(start, angle0, angle1, radius)) }
}

public extension AnyTikzItem {
    public init(_ rawPoint: TikzPoint.Raw) {
        self.init(TikzPoint(rawPoint.0, rawPoint.1))
    }
}
