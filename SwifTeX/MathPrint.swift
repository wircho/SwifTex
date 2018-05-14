//
//  MathPrint.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-09.
//  Copyright © 2018 Wircho. All rights reserved.
//

internal func join(_ maths: [MathCodable]) -> String {
    var result = ""
    var leftEnd: Math.CodeEnd? = nil
    return maths.reduce("") {
        (string, math) in
        defer { leftEnd = math.codeEnd.right }
        guard let leftEnd = leftEnd else {
            return string + math.code
        }
        switch (leftEnd, math.codeEnd.left) {
        case (.number, .number), (.letter, .letter): return string + " " + math.code
        case (.number, .letter), (.letter, .number), (_, .symbol), (.symbol, _): return string + math.code
        }
    }
}

internal func join(_ maths: MathCodable ...) -> String { return join(maths) }

extension Math.InnerContent: MathCodable {
    var codeEnd: (left: Math.CodeEnd, right: Math.CodeEnd) {
        switch self {
        case let .bracket(bracket, _, _):
            switch bracket {
            case .curly, .flat, .round, .square: return (.symbol, .symbol)
            }
        case let .literal(literal): return literal.codeEnd
        case let .operation(op, lhs, rhs):
            switch op {
            case .fraction: return (.symbol, rhs.codeEnd.right)
            case .loop, .multiplication, .of, .other, .over, .sub, .subtraction, .sum, .toThe: return (lhs.codeEnd.left, rhs.codeEnd.right)
            }
        case let .prefix(prefix, inner): return (prefix.codeEnd.left, inner.codeEnd.right)
        case let .postfix(postfix, inner): return (inner.codeEnd.left, postfix.codeEnd.right)
        }
    }
    
    var renderEnd: (left: Math.RenderEnd, right: Math.RenderEnd) {
        switch self {
        case .bracket: return (.symbol, .symbol)
        case let .literal(literal): return literal.renderEnd
        case let .operation(op, lhs, rhs):
            switch op {
            case .fraction: return (.fraction, .fraction)
            case .multiplication, .of, .other, .over, .subtraction, .sum, .loop: return (lhs.renderEnd.left, rhs.renderEnd.right)
            case .sub, .toThe: return (lhs.renderEnd.left, lhs.renderEnd.right)
            }
        case let .prefix(prefix, inner): return (prefix.renderEnd.left, inner.renderEnd.right)
        case let .postfix(postfix, inner): return (inner.renderEnd.left, postfix.renderEnd.right)
        }
    }
    
    internal var code: String {
        switch self {
        case let .prefix(prefix, math): return join(prefix, math)
        case let .postfix(postfix, math): return join(math, postfix)
        case let .bracket(bracket, tall, math): return tall ? bracket.mathTallEnclose(math.code) : bracket.mathEnclose(math.code)
        case let .literal(literal): return literal.code
        case let .operation(op, lhs, rhs): return op.code(lhs: lhs, rhs: rhs)
        }
    }
}

extension Math.Content: MathCodable {
    var codeEnd: (left: Math.CodeEnd, right: Math.CodeEnd) {
        switch shell {
        case .grouped, .displayStyle: return (.symbol, .symbol)
        case .none: return inner.codeEnd
        }
    }
    
    var renderEnd: (left: Math.RenderEnd, right: Math.RenderEnd) {
        return inner.renderEnd
    }
    
    var code: String {
        switch shell {
        case .grouped: return Bracket.curly.enclose(inner.code)
        case .displayStyle: return Bracket.curly.enclose(join(Math.Literal.displayStyle, inner))
        case .none: return inner.code
        }
    }
}

internal extension Math.Operation {
    internal func code(lhs: Math.Content, rhs: Math.Content) -> String {
        switch self {
        case .loop: return join(lhs, rhs)
        case .of:
            switch rhs.inner {
            case let .bracket(bracket, _, _):
                switch bracket {
                case .round: return join(lhs, rhs)
                case .flat, .square, .curly: return join(lhs/*, Math.Literal.space*/, rhs)
                }
            case .literal, .operation, .prefix, .postfix: return join(lhs/*, Math.Literal.space*/, rhs)
            }
        case .fraction: return join(Math.Literal.frac, lhs, rhs)
        case let .multiplication(separator):
            guard let separator = separator else { return join(lhs, rhs) }
            return join(lhs, separator, rhs)
        case let .other(separator):
            guard let separator = separator else { return join(lhs, rhs) }
            return join(lhs, separator, rhs)
        case .over: return join(lhs, Math.Literal.over, rhs)
        case .sub: return join(lhs, Math.Literal.sub, rhs)
        case .subtraction: return join(lhs, Math.Literal.minus, rhs)
        case .sum: return join(lhs, Math.Literal.plus, rhs)
        case .toThe: return join(lhs, Math.Literal.toThe, rhs)
        }
    }
}

extension Math: CustomStringConvertible {
    fileprivate var begin: String {
        return display ? "$$" : "$"
    }
    
    fileprivate var end: String {
        return display ? "$$" : "$"
    }
    
    public var description: String {
        return literal(begin + content.code + end)
    }
}

public struct PrintedMath: CustomStringConvertible {
    internal let math: Math
    internal let ending: String
    
    public var description: String {
        return literal(math.begin + math.content.code + ending + math.end)
    }
}

public extension Math {
    public var comma: PrintedMath {
        return PrintedMath(math: self, ending: ",")
    }
    
    public var period: PrintedMath {
        return PrintedMath(math: self, ending: ".")
    }
}

public extension Array where Element == Math {
    public var comma: PrintedMath {
        return Math(array: self).comma
    }
    
    public var period: PrintedMath {
        return Math(array: self).period
    }
}
