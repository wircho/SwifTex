//
//  TikzPoint.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-17.
//  Copyright © 2018 Wircho. All rights reserved.
//

public struct TikzPoint {
    public var x: LengthProtocol
    public var y: LengthProtocol
    
    init(_ x: LengthProtocol, _ y: LengthProtocol) {
        self.x = x
        self.y = y
    }
}

extension TikzPoint: TikzItem {
    public typealias Raw = (LengthProtocol, LengthProtocol)
    public var start: Raw { return (x, y) }
    public var description: String { return "(\(x), \(y))" }
    public var headers: [String] { return [] }
}

