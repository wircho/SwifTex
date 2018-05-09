//
//  MathGroup.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-09.
//  Copyright © 2018 Wircho. All rights reserved.
//

internal extension Math {
    internal static func group(_ math: Math, `for` precedence: Precedence) -> Math {
        let associative = precedence.associative
        return ((associative && math.precedence < precedence) || (!associative && math.precedence <= precedence)) ? .round(math) : math
    }
}
