//
//  MathConcat.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-09.
//  Copyright © 2018 Wircho. All rights reserved.
//

internal extension Math {
    internal init(display: Bool? = nil, displayStyle: Bool = false, precedence: Precedence, concat math: [Math]) {
        self.init(
            display: display ?? math.first?.display ?? false,
            displayStyle: displayStyle,
            precedence: precedence,
            singleHeight: math.reduce(true) { $0 && $1.singleHeight },
            shell: (math.first?.shell.left ?? .nothing, math.last?.shell.right ?? .nothing),
            code: math.map { $0.innerCode }.joined(separator: "")
        )
    }
}
