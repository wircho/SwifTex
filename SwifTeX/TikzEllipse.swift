//
//  TikzEllipse.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-17.
//  Copyright © 2018 Wircho. All rights reserved.
//

public struct TikzEllipse {
    public let center: TikzPoint.Raw
    public let radius0: LengthProtocol
    public let radius1: LengthProtocol
    
    public init(_ center: TikzPoint.Raw, _ radius0: LengthProtocol, _ radius1: LengthProtocol) {
        self.center = center
        self.radius0 = radius0
        self.radius1 = radius1
    }
}

extension TikzEllipse: TikzItem {
    public var start: TikzPoint.Raw { return center }
    public var description: String { return "(\(center.0), \(center.1)) ellipse (\(radius0) and \(radius1))" }
}
