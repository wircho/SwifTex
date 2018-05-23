//
//  TikzCurve.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-22.
//  Copyright © 2018 Wircho. All rights reserved.
//

public struct TikzCurve {
    public let start: TikzPoint.Raw
    public let control0: TikzPoint.Raw
    public let control1: TikzPoint.Raw
    public let end: TikzPoint.Raw
    
    public init(_ start: TikzPoint.Raw, _ control0: TikzPoint.Raw, _ control1: TikzPoint.Raw, _ end: TikzPoint.Raw) {
        self.start = start
        self.control0 = control0
        self.control1 = control1
        self.end = end
    }
}

extension TikzCurve: TikzItem {
    public var description: String { return "(\(start.0), \(start.1)) .. controls (\(control0.0), \(control0.1)) and (\(control1.0), \(control1.1)) .. (\(end.0), \(end.1))" }
    public var headers: [String] { return [] }
}
