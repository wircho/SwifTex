//
//  MathFunctions.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-09.
//  Copyright © 2018 Wircho. All rights reserved.
//

public extension Math {
    public static func sum(_ low: Math, _ high: Math? = nil, of argument: Math) -> Math {
        let groupedArgument = Math.group(argument, for: .multiplication)
        let highCode = high.map { "^{" + $0.innerCode + "}" } ?? ""
        return Math(
            display: false,
            displayStyle: false,
            precedence: .multiplication,
            singleHeight: false,
            shell: (.letter, groupedArgument.shell.right),
            code: "\\sum_{" + low.innerCode + "}" + highCode + " " + groupedArgument.innerCode
        )
    }
    
    public func sub(_ rhs: Math ...) -> Math {
        let groupedSelf = Math.group(self, for: .subscripting)
        let listRHS = Math(display: false, displayStyle: false, list: rhs)
        return Math(
            display: display,
            displayStyle: false,
            precedence: .subscripting,
            singleHeight: false,
            shell: (groupedSelf.shell.left, .exponent),
            code: groupedSelf.innerCode + "_{" + listRHS.innerCode + "}"
        )
    }
    
    public func sub(_ from: Math, to: Math) -> Math {
        return Math(self.sub(from), .ldots, self.sub(to))
    }
    
    public func of(_ math: Math ...) -> Math {
        return Math(display: false, displayStyle: false, precedence: .group, concat: [self, Math.bracket(.round, math)])
    }
    
    public func isIn(displayStyle: Bool = false, _ set: Math) -> Math {
        return Math(display: display, displayStyle: displayStyle, precedence: .multiplication, concat: [self, .in, set])
    }
    
    public var abs: Math {
        return Math.abs(self)
    }
    
    public func det(`for` subs: Math) -> Math {
        return Math.det(self, for: subs)
    }
}

public extension Math {
    //    public static func list(_ from: Math, to: Math) -> Math {
    //        return Math(from, .ldots, to)
    //    }
    
    //    public static func times(_ from: Math, to: Math) -> Math {
    //        return .times(from, .ldots, to)
    //    }
    
    public static func set(_ math: Math ...) -> Math {
        return curly(Math(display: false, displayStyle: false, list: math))
    }
    
    public static func set(_ from: Math, to: Math) -> Math {
        return set(from, .ldots, to)
    }
    
    public static func tuple(_ math: Math ...) -> Math {
        return round(Math(display: false, displayStyle: false, list: math))
    }
    
    public static func tuple(_ from: Math, to: Math) -> Math {
        return tuple(from, .ldots, to)
    }
    
    public static func det(_ entry: Math, `for` subs: Math? = nil) -> Math  {
        guard let subs = subs else {
            return Math.det.of(entry)
        }
        return Math.det.of(entry).sub(subs)
    }
    
    public static func sign(_ math: Math) -> Math  {
        return Math.sign.of(math)
    }
    
    public static func abs(_ math: Math ...) -> Math {
        return bracket(.flat, math)
    }
    
    public static func cal(_ math: Math) -> Math {
        return Math(display: false, displayStyle: false, precedence: math.precedence, singleHeight: math.singleHeight, shell: math.shell, code: "\\mathcal{" + math.innerCode + "}")
    }
}

public extension String {
    public func sub(_ rhs: Math) -> Math {
        return Math(stringLiteral: self).sub(rhs)
    }
    
    public func sub(_ from: Math, to: Math) -> Math {
        let selfMath = Math(stringLiteral: self)
        return selfMath.sub(from, to: to)
    }
}

public extension Array where Element == Math {
    public func isIn(_ set: Math) -> Math {
        return Math(array: self).isIn(set)
    }
}
