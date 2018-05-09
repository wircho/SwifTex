//
//  MathDisplayOperator.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-09.
//  Copyright © 2018 Wircho. All rights reserved.
//

prefix operator §

public extension Math {
    public static prefix func §(_ math: Math) -> Math {
        return Math(display: true, precedence: math.precedence, singleHeight: math.singleHeight, shell: math.shell, code: math.code)
    }
}
