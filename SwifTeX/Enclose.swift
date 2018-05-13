//
//  Enclose.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-05.
//  Copyright © 2018 Wircho. All rights reserved.
//

internal extension Document {
    internal func enclose(_ name: String, parameter: (left: EncloseParameter, right: EncloseParameter) = (.none, .none), closure: (Document) -> Void) {
        self <!- "\\begin\(parameter.left)\(Bracket.curly.escape(name))\(parameter.right)\n"
        closure(self)
        self <!- "\n\\end\(Bracket.curly.escape(name))"
    }
}
