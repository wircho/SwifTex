//
//  MathLiterals.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-09.
//  Copyright © 2018 Wircho. All rights reserved.
//


extension Math: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self.init(display: false, displayStyle: false, precedence: .group, singleHeight: true, shell: (.number, .number), code: "\(value)")
    }
}

extension Math: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Float) {
        self.init(display: false, displayStyle: false, precedence: .group, singleHeight: true, shell: (.number, .number), code: "\(value)")
    }
}

extension Math: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(display: false, displayStyle: false, precedence: .group, singleHeight: true, shell: (.letter, .letter), code: forceEscape(value))
    }
}

extension Math: ExpressibleByArrayLiteral {
    internal init(array: [Math]) {
        self.init(display: false, displayStyle: false, list: array)
    }
    
    public init(arrayLiteral: Math ...) {
        self.init(array: arrayLiteral)
    }
}
