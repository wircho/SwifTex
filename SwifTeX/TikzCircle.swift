//
//  TikzCircle.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-16.
//  Copyright © 2018 Wircho. All rights reserved.
//

public struct TikzCircle {
    public let center: TikzPoint.Raw
    public let radius: LengthProtocol
    
    public init(_ center: TikzPoint.Raw, _ radius: LengthProtocol) {
        self.center = center
        self.radius = radius
    }
}

extension TikzCircle: TikzItem {
    public var start: TikzPoint.Raw { return center }
    public var description: String { return "(\(center.0), \(center.1)) circle (\(radius))" }
    public var headers: [String] { return [] }
}
