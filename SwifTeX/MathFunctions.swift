//
//  MathFunctions.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-09.
//  Copyright © 2018 Wircho. All rights reserved.
//

public extension Math {
    public static func sum(_ low: Math, _ high: Math? = nil, of arg: Math) -> Math {
        let sum = Math(content: .literal(.sum))
        let lhs = (high.map { sum ^ $0 } ?? sum).sub(math: low)
        return Math(
            display: arg.display,
            content: Math.Content(
                inner: .operation(
                    .loop,
                    lhs: lhs.content,
                    rhs: arg.content
                ),
                shell: .none)
        )
    }
}

public extension Math {
    public static func abs(_ math: Math ...) -> Math {
        return bracket(.flat, math)
    }
}

public extension Math {
    public static func det(_ math: Math) -> Math {
        return Math.det.of(math)
    }
}

public extension Math {
    public static func set(_ math: Math ...) -> Math {
        return curly(Math(list: math))
    }
    
    public static func set(_ from: Math, to: Math) -> Math {
        return set(from, .ldots, to)
    }
}

public extension Math {
    
    public static func tuple(_ math: Math ...) -> Math {
        return round(Math(list: math))
    }
    
    public static func tuple(_ from: Math, to: Math) -> Math {
        return tuple(from, .ldots, to)
    }
    
    public static func sign(_ math: Math) -> Math  {
        return Math.sign.of(math)
    }
    
    public static func cal(_ string: String) -> Math {
        // TODO: Prevent code injection
        return Math(content: Math.Content(inner: .literal(Math.Literal(code: "\\mathcal{\(string)}", short: true, single: true, codeEnd: (.symbol, .symbol), renderEnd: (.prettyLetter, .prettyLetter))), shell: .none))
    }
}
