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
        return Math(display: true, content: math.content)
    }
}

public extension PrintedMath {
    public static prefix func §(_ printed: PrintedMath) -> PrintedMath {
        return PrintedMath(math: Math(display: true, content: printed.math.content), ending: printed.ending)
    }
}
