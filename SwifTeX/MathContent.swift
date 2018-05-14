//
//  MathContent.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-10.
//  Copyright © 2018 Wircho. All rights reserved.
//

internal extension Math.Content {
    internal var short: Bool {
        switch inner {
        case let .prefix(prefix, inner): return prefix.short && inner.short
        case let .postfix(postfix, inner): return postfix.short && inner.short
        case .bracket: return false
        case let .literal(literal): return literal.short
        case let .operation(op, lhs, rhs):
            switch op {
            case .fraction, .toThe, .sub: return false
            case .loop, .of, .over, .sum, .subtraction: return lhs.short && rhs.short
            case let .multiplication(separator): return (separator?.short ?? true) && lhs.short && rhs.short
            case let .other(separator): return (separator?.short ?? true) && lhs.short && rhs.short
            }
        }
    }
    
    internal var single: Bool {
        switch shell {
        case .grouped, .displayStyle: return true
        case .none:
            switch inner {
            case .bracket, .prefix, .postfix: return false
            case let .literal(literal): return literal.single
            case let .operation(op, _, _):
                switch op {
                case .fraction: return true
                case .loop, .multiplication, .of, .other, .sum, .subtraction, .over, .sub, .toThe: return false
                }
            }
        }
    }
}

internal extension Math {
    internal var short: Bool { return content.short }
}

internal extension Math.Content {
    internal static func prefix(_ prefix: Math.Literal, inner: Math.Content) -> Math.Content {
        return Math.Content(inner: .prefix(prefix, inner: inner), shell: .none)
    }
    
    internal static func postfix(_ postfix: Math.Literal, inner: Math.Content) -> Math.Content {
        return Math.Content(inner: .postfix(postfix, inner: inner), shell: .none)
    }
    
    internal static func literal(_ literal: Math.Literal) -> Math.Content {
        return Math.Content(inner: .literal(literal), shell: .none)
    }
    
    internal static func bracket(_ bracket: Bracket, tall: Bool, inner: Math.Content) -> Math.Content {
        return Math.Content(inner: .bracket(bracket, tall: tall, inner: inner), shell: .none)
    }
    
    internal static func operation(_ op: Math.Operation, lhs: Math.Content, rhs: Math.Content) -> Math.Content {
        return Math.Content(inner: .operation(op, lhs: lhs, rhs: rhs), shell: .none)
    }
}
