//
//  MathFunctions.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-09.
//  Copyright © 2018 Wircho. All rights reserved.
//

public extension Math {
    internal static func loop(_ symbol: Math.Literal,_ low: Math, _ high: Math?, of argument: Math) -> Math {
        let mathSymbol = Math(content: .literal(symbol))
        let loop = (high.map { mathSymbol ^ $0 } ?? mathSymbol).sub(math: low)
        return Math(
            display: argument.display,
            content: Math.Content(
                inner: .operation(
                    .loop,
                    lhs: loop.content,
                    rhs: argument.content
                ),
                shell: .none)
        )
    }
    
    public static func sum(_ low: Math, _ high: Math? = nil, of argument: Math) -> Math {
        return loop(.sum, low, high, of: argument)
    }
    
    public static func union(_ low: Math, _ high: Math? = nil, of argument: Math) -> Math {
        return loop(.bigcup, low, high, of: argument)
    }
    
    public static func intersection(_ low: Math, _ high: Math? = nil, of argument: Math) -> Math {
        return loop(.bigcap, low, high, of: argument)
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
    
    public static func bf(_ string: String) -> Math {
        // TODO: Prevent code injection
        return Math(content: Math.Content(inner: .literal(Math.Literal(code: "\\mathbf{\(string)}", short: true, single: true, codeEnd: (.symbol, .symbol), renderEnd: (.prettyLetter, .prettyLetter))), shell: .none))
    }
}
