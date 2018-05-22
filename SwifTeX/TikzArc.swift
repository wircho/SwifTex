//
//  TikzArc.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-21.
//  Copyright © 2018 Wircho. All rights reserved.
//

public struct TikzArc {
    public let start: TikzPoint.Raw
    public let angle0: Float
    public let angle1: Float
    public let radius: LengthProtocol
    
    public init(_ start: TikzPoint.Raw, _ angle0: Float, _ angle1: Float, _ radius: LengthProtocol) {
        self.start = start
        self.angle0 = angle0
        self.angle1 = angle1
        self.radius = radius
    }
}

extension TikzArc: TikzItem {
    public var description: String { return "(\(start.0), \(start.1)) arc (\(angle0):\(angle1):\(radius))" }
}
