//
//  Enclose.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-05.
//  Copyright © 2018 Wircho. All rights reserved.
//

internal extension Document {
    internal func enclose(_ type: String, before: String = "", after: String = "", closure: (Document) -> Void) {
        self <!- "\\begin\(before)\(Bracket.curly.escape(type))\(after)\n"
        closure(self)
        self <!- "\n\\end\(Bracket.curly.escape(type))"
    }
    
    internal func enclose(_ type: String, requiredTitle: String, closure: (Document) -> Void) {
        enclose(type, after: Bracket.curly.escape(requiredTitle), closure: closure)
    }
    
    internal func enclose(_ type: String, optionalTitle: String?, closure: (Document) -> Void) {
        enclose(type, after: Bracket.square.escape(optionalTitle), closure: closure)
    }
}
