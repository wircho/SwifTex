//
//  MathLiteralExpressible.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-09.
//  Copyright © 2018 Wircho. All rights reserved.
//


extension Math: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self.init(display: false, displayStyle: false, content: .literal(Math.Literal(code: "\(value)", short: true, single: true, codeEnd: (.number, .number), renderEnd: (.number, .number))))
    }
}

extension Math: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Float) {
        self.init(display: false, displayStyle: false, content: .literal(Math.Literal(code: "\(value)", short: true, single: true, codeEnd: (.number, .number), renderEnd: (.number, .number))))
    }
}

extension Math: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        // TODO: Do not assume strings are letters
        self.init(display: false, displayStyle: false, content: .literal(Math.Literal(code: value, short: true, single: true, codeEnd: (.letter, .letter), renderEnd: (.letter, .letter))))
    }
}

extension Math: ExpressibleByArrayLiteral {
    internal init(array: [Math]) {
        self.init(list: array)
    }
    
    public init(arrayLiteral: Math ...) {
        self.init(array: arrayLiteral)
    }
}
