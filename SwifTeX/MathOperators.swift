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
    lowerThan: LogicalDisjunctionPrecedence
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

internal extension Math.Content {
    private var rounded: Math.Content {
        return Math.Content(inner: .bracket(.round, tall: !short, inner: self), shell: .none)
    }
    
    internal var forAddition: Math.Content {
        switch inner {
        case .prefix, .bracket, .literal: return self
        case let .operation(op, _, _):
            switch op {
            case .fraction, .loop, .multiplication, .of, .over, .sub, .subtraction, .sum, .toThe: return self
            case .other: return rounded
            }
        }
    }
    
    internal var forRightSubtraction: Math.Content {
        switch inner {
        case .bracket, .literal, .prefix: return self
        case let .operation(op, _, _):
            switch op {
            case .fraction, .loop, .multiplication, .of, .over, .sub, .toThe: return self
            case .subtraction, .sum, .other: return rounded
            }
        }
    }
    
    internal var forLeftMultiplication: Math.Content {
        switch inner {
        case .prefix, .bracket, .literal: return self
        case let .operation(op, _, _):
            switch op {
            case .fraction, .loop, .multiplication, .of, .sub, .toThe: return self
            case .over, .subtraction, .sum, .other: return rounded
            }
        }
    }
    
    internal var forRightMultiplication: Math.Content {
        switch inner {
        case .prefix, .bracket, .literal: return self
        case let .operation(op, _, _):
            switch op {
            case .fraction, .loop, .multiplication, .of, .sub, .toThe, .over: return self
            case .subtraction, .sum, .other: return rounded
            }
        }
    }
    
    private var forRightDivision: Math.Content {
        return forLeftMultiplication
    }
    
    internal var asSingleOrGrouped: Math.Content {
        guard single else {
            return Math.Content(inner: inner, shell: .grouped)
        }
        return self
    }
    
    internal var asSingleOrRounded: Math.Content {
        guard single else { return rounded }
        return self
    }
    
    internal var asExponentBase: Math.Content {
        switch inner {
        case .bracket, .literal: return self
        case .prefix: return rounded
        case let .operation(op, lhs, _):
            switch op {
            case .of: return self
            case .fraction, .loop, .multiplication, .other, .over, .subtraction, .sum, .toThe: return rounded
            case .sub:
                switch lhs.inner {
                case let .operation(op, _, _):
                    switch op {
                    case .fraction, .loop, .multiplication, .of, .other, .over, .subtraction, .sum, .sub: return self
                    case .toThe: return rounded
                    }
                case .bracket, .literal, .prefix: return self
                }
            }
        }
    }
    
    internal var asSubscriptBase: Math.Content {
        switch inner {
        case .bracket, .literal, .prefix: return self
        case let .operation(op, lhs, _):
            switch op {
            case .of: return self
            case .fraction, .loop, .multiplication, .other, .over, .subtraction, .sum, .sub: return rounded
            case .toThe:
                switch lhs.inner {
                case let .operation(op, _, _):
                    switch op {
                    case .fraction, .loop, .multiplication, .of, .other, .over, .subtraction, .sum, .toThe: return self
                    case .sub: return rounded
                    }
                case .bracket, .literal, .prefix: return self
                }
            }
        }
    }
    
    internal var asFunction: Math.Content {
        switch inner {
        case .literal, .prefix, .bracket: return self
        case let .operation(op, _, _):
            switch op {
            case .fraction, .sub, .toThe, .of: return self
            case .loop, .multiplication, .other, .over, .subtraction, .sum: return rounded
            }
        }
    }
    
    internal var asRoundedFunctionArgument: Math.Content {
        switch inner {
        case .literal, .operation, .prefix: return rounded
        case let .bracket(bracket, _, _):
            switch bracket {
            case .curly, .square, .flat: return rounded
            case .round: return self
            }
        }
    }
    
    internal func asFunctionArgument(of f: Math.Content) -> Math.Content {
        switch f.inner {
        case .bracket, .operation, .prefix: return asRoundedFunctionArgument
        case let .literal(literal):
            switch literal.renderEnd {
            case (.applyingLetter, .applyingLetter): return asSingleOrRounded
            default: return asRoundedFunctionArgument
            }
        }
    }
}

internal extension Math.Content {
    
    internal static func +(lhs: Math.Content, rhs: Math.Content) -> Math.Content {
        return operation(.sum, lhs: lhs.forAddition, rhs: rhs.forAddition)
    }
    
    internal static func -(lhs: Math.Content, rhs: Math.Content) -> Math.Content {
        return operation(.subtraction, lhs: lhs.forAddition, rhs: rhs.forRightSubtraction)
    }
    
    internal static prefix func -(inner: Math.Content) -> Math.Content {
        return prefix(.minus, inner: inner.forRightSubtraction)
    }
    
    private static func multiply(_ op: Math.Literal, lhs: Math.Content, rhs: Math.Content) -> Math.Content {
        return operation(.multiplication(op), lhs: lhs.forLeftMultiplication, rhs: rhs.forRightMultiplication)
    }
    
    internal static func *(lhs: Math.Content, rhs: Math.Content) -> Math.Content {
        let times: Math.Literal
        switch (lhs.renderEnd.right, rhs.renderEnd.left) {
        case (.number, .number): times = .times
        case (.fraction, .fraction): times = .space
        default: times = .empty
        }
        return multiply(times, lhs: lhs.forLeftMultiplication, rhs: rhs.forRightMultiplication)
    }
    
    internal static func /(lhs: Math.Content, rhs: Math.Content) -> Math.Content {
        return operation(.over, lhs: lhs.forLeftMultiplication, rhs: rhs.forRightDivision)
    }
    
    internal static func ***(lhs: Math.Content, rhs: Math.Content) -> Math.Content {
        return multiply(.times, lhs: lhs.forLeftMultiplication, rhs: rhs.forRightMultiplication)
    }
    
    internal static func *…*(lhs: Math.Content, rhs: Math.Content) -> Math.Content {
        return operation(.other(.cdotsInSpaces), lhs: lhs.forLeftMultiplication, rhs: rhs.forLeftMultiplication)
    }
    
    internal static func **…**(lhs: Math.Content, rhs: Math.Content) -> Math.Content {
        return operation(.other(.cdotsInTimes), lhs: lhs.forLeftMultiplication, rhs: rhs.forLeftMultiplication)
    }
    
    internal static func ÷(lhs: Math.Content, rhs: Math.Content) -> Math.Content {
        return operation(.fraction, lhs: lhs.asSingleOrGrouped, rhs: rhs.asSingleOrGrouped)
    }
    
    internal static func ^(lhs: Math.Content, rhs: Math.Content) -> Math.Content {
        return operation(.toThe, lhs: lhs.asExponentBase, rhs: rhs.asSingleOrGrouped)
    }
    
    internal static func *=*(lhs: Math.Content, rhs: Math.Content) -> Math.Content {
        return operation(.other(.equals), lhs: lhs, rhs: rhs)
    }
    
    internal static func ==(lhs: Math.Content, rhs: Math.Content) -> Math.Content {
        return operation(.other(.equals), lhs: lhs, rhs: rhs)
    }
    
    internal static func <-(lhs: Math.Content, rhs: Math.Content) -> Math.Content {
        return operation(.other(.assign), lhs: lhs, rhs: rhs)
    }
    
    internal static func <(lhs: Math.Content, rhs: Math.Content) -> Math.Content {
        return operation(.other(.lt), lhs: lhs, rhs: rhs)
    }
    
    internal static func >(lhs: Math.Content, rhs: Math.Content) -> Math.Content {
        return operation(.other(.gt), lhs: lhs, rhs: rhs)
    }
    
    internal static func <=(lhs: Math.Content, rhs: Math.Content) -> Math.Content {
        return operation(.other(.leq), lhs: lhs, rhs: rhs)
    }
    
    internal static func >=(lhs: Math.Content, rhs: Math.Content) -> Math.Content {
        return operation(.other(.geq), lhs: lhs, rhs: rhs)
    }
}

extension Math {
    public static func +(lhs: Math, rhs: Math) -> Math {
        return Math(display: lhs.display, content: lhs.content + rhs.content)
    }
    
    public static func -(lhs: Math, rhs: Math) -> Math {
        return Math(display: lhs.display, content: lhs.content - rhs.content)
    }
    
    public static prefix func -(inner: Math) -> Math {
        return Math(display: inner.display, content: -inner.content)
    }
 
    public static func *(lhs: Math, rhs: Math) -> Math {
        return Math(display: lhs.display, content: lhs.content * rhs.content)
    }
    
    public static func /(lhs: Math, rhs: Math) -> Math {
        return Math(display: lhs.display, content: lhs.content / rhs.content)
    }
    
    public static func ***(lhs: Math, rhs: Math) -> Math {
        return Math(display: lhs.display, content: lhs.content *** rhs.content)
    }
    
    public static func …(lhs: Math, rhs: Math) -> Math {
        return Math(lhs, to: rhs)
    }
    
    public static func *…*(lhs: Math, rhs: Math) -> Math {
        return Math(display: lhs.display, content: lhs.content *…* rhs.content)
    }
    
    public static func **…**(lhs: Math, rhs: Math) -> Math {
        return Math(display: lhs.display, content: lhs.content **…** rhs.content)
    }
    
    public static func ÷(lhs: Math, rhs: Math) -> Math {
        return Math(display: lhs.display, content: lhs.content ÷ rhs.content)
    }
    
    public static func ^(lhs: Math, rhs: Math) -> Math {
        return Math(display: lhs.display, content: lhs.content ^ rhs.content)
    }
    
    public static func *=*(lhs: Math, rhs: Math) -> Math {
        return Math(display: lhs.display, content: lhs.content *=* rhs.content)
    }
    
    public static func ==(lhs: Math, rhs: Math) -> Math {
        return Math(display: lhs.display, content: lhs.content == rhs.content)
    }
    
    public static func <-(lhs: Math, rhs: Math) -> Math {
        return Math(display: lhs.display, content: lhs.content <- rhs.content)
    }
    
    public static func <(lhs: Math, rhs: Math) -> Math {
        return Math(display: lhs.display, content: lhs.content < rhs.content)
    }
    
    public static func >(lhs: Math, rhs: Math) -> Math {
        return Math(display: lhs.display, content: lhs.content > rhs.content)
    }
    
    public static func <=(lhs: Math, rhs: Math) -> Math {
        return Math(display: lhs.display, content: lhs.content <= rhs.content)
    }
    
    public static func >=(lhs: Math, rhs: Math) -> Math {
        return Math(display: lhs.display, content: lhs.content >= rhs.content)
    }
    
    public static func ≤(lhs: Math, rhs: Math) -> Math {
        return Math(display: lhs.display, content: lhs.content <= rhs.content)
    }
    
    public static func ≥(lhs: Math, rhs: Math) -> Math {
        return Math(display: lhs.display, content: lhs.content >= rhs.content)
    }
}

