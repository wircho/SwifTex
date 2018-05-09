//
//  MathPrint.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-09.
//  Copyright © 2018 Wircho. All rights reserved.
//

internal extension Math {
    private var begin: String {
        return display ? "$$" : "$"
    }
    
    private var end: String {
        return display ? "$$" : "$"
    }
    
    internal var innerCode: String {
        return displayStyle ? "{\\displaystyle \(code)}" : code
    }
}

extension Math: CustomStringConvertible {
    public var description: String {
        return literal(begin + innerCode + end)
    }
}
