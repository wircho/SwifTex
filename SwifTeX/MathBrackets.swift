//
//  MathBrackets.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-09.
//  Copyright © 2018 Wircho. All rights reserved.
//

fileprivate extension Bracket {
    fileprivate func mathEnclose(_ string: String) -> String {
        switch self {
        case .curly: return "\\{\(string)\\}"
        case .square, .round, .flat: return enclose(string)
        }
    }
    
    fileprivate func mathTallEnclose(_ string: String) -> String {
        switch self {
        case .curly: return "\\left\\{\(string)\\right\\}"
        case .square: return "\\left[\(string)\\right]"
        case .round: return "\\left(\(string)\\right)"
        case .flat: return "\\left|\(string)\\right|"
        }
    }
}

extension Math {
    internal static func bracket(_ type: Bracket, display: Bool? = nil, displayStyle: Bool = false, tall: Bool = false, _ math: [Math]) -> Math {
        let listMath = Math(list: math)
        let notTall = !tall && listMath.singleHeight
        let code = notTall ? type.mathEnclose(listMath.innerCode) : type.mathTallEnclose(listMath.innerCode)
        return Math(
            display: display ?? math.first?.display ?? false,
            displayStyle: displayStyle,
            precedence: .group,
            singleHeight: false,
            shell: (.bracket, .bracket),
            code: code
        )
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
