//
//  MathOperators.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-09.
//  Copyright © 2018 Wircho. All rights reserved.
//

precedencegroup PowerPrecedence {
    associativity: right
    higherThan: MultiplicationPrecedence
}

precedencegroup AssociativeAssignmentPrecedence {
    associativity: right
    higherThan: AssignmentPrecedence
}

infix operator ÷: MultiplicationPrecedence
infix operator ^: PowerPrecedence
infix operator …: PowerPrecedence
infix operator *…*: PowerPrecedence
infix operator **…**: PowerPrecedence
infix operator ***: PowerPrecedence
infix operator *=*: AssociativeAssignmentPrecedence
infix operator *<*: AssociativeAssignmentPrecedence
infix operator *>*: AssociativeAssignmentPrecedence
infix operator *<=*: AssociativeAssignmentPrecedence
infix operator *>=*: AssociativeAssignmentPrecedence
infix operator ≤: AssociativeAssignmentPrecedence
infix operator ≥: AssociativeAssignmentPrecedence

extension Math {
    public static func +(lhs: Math, rhs: Math) -> Math {
        let groupedLHS = Math.group(lhs, for: .addition)
        let groupedRHS = Math.group(rhs, for: .addition)
        return Math(precedence: .addition, concat: [groupedLHS, .plus, groupedRHS])
    }
    
    static func join(precedence: Precedence, lhs: Math, rhs: Math, symbol: Math) -> Math {
        return Math(precedence: precedence, concat: [lhs, symbol, rhs])
    }
    
    static func multiplyGrouped(lhs groupedLHS: Math, rhs groupedRHS: Math, useTimes: Bool = false) -> Math {
        let symbol: Math
        switch (useTimes, groupedLHS.shell.right, groupedRHS.shell.left) {
        case (_, .fraction, .fraction): symbol = .space
        case (true, _, _), (_, .number, .number): symbol = .times
        default: symbol = .nothing
        }
        return join(precedence: .multiplication, lhs: groupedLHS, rhs: groupedRHS, symbol: symbol)
    }
    
    public static func *(lhs: Math, rhs: Math) -> Math {
        let groupedLHS = Math.group(lhs, for: .multiplication)
        let groupedRHS = Math.group(rhs, for: .multiplication)
        return multiplyGrouped(lhs: groupedLHS, rhs: groupedRHS)
    }
    
    public static func ***(lhs: Math, rhs: Math) -> Math {
        let groupedLHS = Math.group(lhs, for: .multiplication)
        let groupedRHS = Math.group(rhs, for: .multiplication)
        return multiplyGrouped(lhs: groupedLHS, rhs: groupedRHS, useTimes: true)
    }
    
    public static func *…*(lhs: Math, rhs: Math) -> Math {
        let groupedLHS = Math.group(lhs, for: .multiplication)
        let groupedRHS = Math.group(rhs, for: .multiplication)
        return join(precedence: .multiplication, lhs: groupedLHS, rhs: groupedRHS, symbol: .cdots)
    }
    
    public static func **…**(lhs: Math, rhs: Math) -> Math {
        let groupedLHS = Math.group(lhs, for: .multiplication)
        let groupedRHS = Math.group(rhs, for: .multiplication)
        return join(precedence: .multiplication, lhs: groupedLHS, rhs: groupedRHS, symbol: Math(precedence: .group, concat: [.space, .times, .space, .cdots, .space, .times, .space]))
    }
    
    public static func /(lhs: Math, rhs: Math) -> Math {
        let groupedLHS = Math.group(lhs, for: .multiplication)
        let groupedRHS = Math.group(rhs, for: .multiplication)
        return join(precedence: .multiplication, lhs: groupedLHS, rhs: groupedRHS, symbol: .over)
    }
    
    public static func ÷(lhs: Math, rhs: Math) -> Math {
        return Math(
            display: lhs.display,
            displayStyle: false,
            precedence: .multiplication,
            singleHeight: false,
            shell: (.fraction, .fraction),
            code: "\\frac{" + lhs.innerCode + "}{" + rhs.innerCode + "}"
        )
    }
    
    public static func ^(lhs: Math, rhs: Math) -> Math {
        let groupedLHS = Math.group(lhs, for: .raising)
        let lhsCode = groupedLHS.precedence <= .multiplication ? "{" + groupedLHS.innerCode + "}" : groupedLHS.innerCode
        return Math(
            display: lhs.display,
            displayStyle: false,
            precedence: .raising,
            singleHeight: false,
            shell: (groupedLHS.shell.left, .exponent),
            code: lhsCode + "^{" + rhs.innerCode + "}"
        )
    }
    
    private static func assignOrCompare(lhs: Math, rhs: Math, symbol: Math) -> Math {
        let groupedLHS = Math.group(lhs, for: .assignment)
        let groupedRHS = Math.group(rhs, for: .assignment)
        return join(precedence: .assignment, lhs: groupedLHS, rhs: groupedRHS, symbol: symbol)
    }
    
    public static func *=*(lhs: Math, rhs: Math) -> Math {
        return assignOrCompare(lhs: lhs, rhs: rhs, symbol: .equals)
    }
    
    public static func <(lhs: Math, rhs: Math) -> Math {
        return assignOrCompare(lhs: lhs, rhs: rhs, symbol: .lt)
    }
    
    public static func >(lhs: Math, rhs: Math) -> Math {
        return assignOrCompare(lhs: lhs, rhs: rhs, symbol: .gt)
    }
    
    public static func <=(lhs: Math, rhs: Math) -> Math {
        return assignOrCompare(lhs: lhs, rhs: rhs, symbol: .leq)
    }
    
    public static func >=(lhs: Math, rhs: Math) -> Math {
        return assignOrCompare(lhs: lhs, rhs: rhs, symbol: .geq)
    }
    
    public static func *<*(lhs: Math, rhs: Math) -> Math {
        return lhs < rhs
    }
    
    public static func *>*(lhs: Math, rhs: Math) -> Math {
        return lhs > rhs
    }
    
    public static func *<=*(lhs: Math, rhs: Math) -> Math {
        return lhs <= rhs
    }
    
    public static func *>=*(lhs: Math, rhs: Math) -> Math {
        return lhs >= rhs
    }
    
    public static func ≤(lhs: Math, rhs: Math) -> Math {
        return lhs <= rhs
    }
    
    public static func ≥(lhs: Math, rhs: Math) -> Math {
        return lhs >= rhs
    }
}

