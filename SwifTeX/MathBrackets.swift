//
//  MathBrackets.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-09.
//  Copyright © 2018 Wircho. All rights reserved.
//

internal extension Bracket {
    internal func mathEnclose(_ string: String) -> String {
        switch self {
        case .curly: return "\\{\(string)\\}"
        case .square, .round, .flat: return enclose(string)
        }
    }
    
    internal func mathTallEnclose(_ string: String) -> String {
        switch self {
        case .curly: return "\\left\\{\(string)\\right\\}"
        case .square: return "\\left[\(string)\\right]"
        case .round: return "\\left(\(string)\\right)"
        case .flat: return "\\left|\(string)\\right|"
        }
    }
}

extension Math {
    internal static func bracket(_ bracket: Bracket, display: Bool? = nil, displayStyle: Bool = false, tall forceTall: Bool = false, _ maths: [Math]) -> Math {
        let listMath = Math(list: maths)
        let tall = forceTall || !listMath.short
        return Math(display: display ?? listMath.display, displayStyle: displayStyle, content: .bracket(bracket, tall: tall, inner: listMath.content))
    }
    
    public static func round(display: Bool? = nil, displayStyle: Bool = false, _ math: Math ...) -> Math {
        return bracket(.round, display: display, displayStyle: displayStyle, math)
    }
    
    public static func square(display: Bool? = nil, displayStyle: Bool = false, _ math: Math ...) -> Math {
        return bracket(.square, display: display, displayStyle: displayStyle, math)
    }
    
    public static func curly(display: Bool? = nil, displayStyle: Bool = false, _ math: Math ...) -> Math {
        return bracket(.curly, display: display, displayStyle: displayStyle, math)
    }
    
    public static func flat(display: Bool? = nil, displayStyle: Bool = false, _ math: Math ...) -> Math {
        return bracket(.flat, display: display, displayStyle: displayStyle, math)
    }
    
    public static func tallRound(display: Bool? = nil, displayStyle: Bool = false, _ math: Math ...) -> Math {
        return bracket(.round, display: display, displayStyle: displayStyle, tall: true, math)
    }
    
    public static func tallSquare(display: Bool? = nil, displayStyle: Bool = false, _ math: Math ...) -> Math {
        return bracket(.square, display: display, displayStyle: displayStyle, tall: true, math)
    }
    
    public static func tallCurly(display: Bool? = nil, displayStyle: Bool = false, _ math: Math ...) -> Math {
        return bracket(.curly, display: display, displayStyle: displayStyle, tall: true, math)
    }
    
    public static func tallFlat(display: Bool? = nil, displayStyle: Bool = false, _ math: Math ...) -> Math {
        return bracket(.flat, display: display, displayStyle: displayStyle, tall: true, math)
    }
}
