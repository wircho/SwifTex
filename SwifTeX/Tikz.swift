//
//  Tikz.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-14.
//  Copyright © 2018 Wircho. All rights reserved.
//

public struct Tikz {
    public var elements: [TikzElement]
    public init(_ elements: TikzElement ...) {
        self.elements = elements
    }
}

public protocol TikzElement {
    var elementCode: String { get }
}

extension Tikz: StringInsertable {
    public var description: String {
        return literal(
            """
            \\begin{tikzpicture}
            \(elements.map{ $0.elementCode }.joined(separator: "\n"))
            \\end{tikzpicture}
            """
        )
    }
}

public extension Tikz {
    public init(content: (inout Tikz) -> Void) {
        var tikz = Tikz()
        content(&tikz)
        self = tikz
    }
}
