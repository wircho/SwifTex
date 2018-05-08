//
//  Math.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-07.
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

prefix operator §
prefix operator §§

infix operator ÷: MultiplicationPrecedence
infix operator ^: PowerPrecedence
infix operator *=*: AssociativeAssignmentPrecedence
infix operator *<*: AssociativeAssignmentPrecedence
infix operator *>*: AssociativeAssignmentPrecedence
infix operator *<=*: AssociativeAssignmentPrecedence
infix operator *>=*: AssociativeAssignmentPrecedence
infix operator ≤: AssociativeAssignmentPrecedence
infix operator ≥: AssociativeAssignmentPrecedence

public struct Math {
    fileprivate enum Precedence: Double {
        case assignment = 1000
        case addition = 2000
        case multiplication = 3000
        case raising = 4000
        case subscripting = 5000
        case group = 6000
        
        var associative: Bool {
            switch self {
            case .assignment, .addition, .multiplication: return true
            case .raising, .subscripting, .group: return false
            }
        }
    }
    
    fileprivate enum Shell: Double {
        case letter
        case number
        case bracket
        case fraction
        case exponent
        case symbol
    }
    
    private let display: Bool
    private let displayStyle: Bool
    private let precedence: Precedence
    private let singleHeight: Bool
    private let shell: (left: Shell, right: Shell)
    private let code: String
    
    private init(display: Bool, displayStyle: Bool, precedence: Precedence, singleHeight: Bool, shell: (left: Shell, right: Shell), code: String) {
        self.display = display
        self.displayStyle = displayStyle
        self.precedence = precedence
        self.singleHeight = singleHeight
        self.shell = shell
        self.code = code
    }
}

public extension Math {
    public static prefix func §§(_ math: Math) -> Math {
        return Math(display: true, displayStyle: false, precedence: math.precedence, singleHeight: math.singleHeight, shell: math.shell, code: math.code)
    }
    
    public static prefix func §(_ math: Math) -> Math {
        return math
    }
}

public extension Math {
    private init(display: Bool, displayStyle: Bool, run math: [Math]) {
        self.init(display: display, displayStyle: displayStyle, precedence: math.first?.precedence ?? .group, singleHeight: math.reduce(true) { $0 && $1.singleHeight }, shell: (math.first?.shell.left ?? .bracket, math.last?.shell.right ?? .bracket), code: "{" + math.map { $0.innerCode }.joined(separator: "}{") + "}")
    }
    
    private init(display: Bool, displayStyle: Bool, list math: [Math]) {
        if math.count <= 1 {
            self.init(display: display, displayStyle: displayStyle, run: math)
            return
        }
        var commaMath = math
        for i in 0 ..< math.count - 1 {
            commaMath.insert(.comma, at: 2 * i + 1)
        }
        self.init(display: display, displayStyle: displayStyle, run: commaMath)
    }
    
    private init(display: Bool, displayStyle: Bool, times math: [Math]) {
        if math.count == 0 {
            self.init(display: display, displayStyle: displayStyle, run: math)
            return
        }
        var commaMath = math
        for i in 0 ..< math.count - 1 {
            commaMath.insert(.times, at: 2 * i + 1)
        }
        self.init(display: display, displayStyle: displayStyle, run: commaMath)
    }
    
    public init(display: Bool, _ math: Math ...) {
        self.init(display: display, displayStyle: false, list: math)
    }
    
    public init(displayStyle: Bool, _ math: Math ...) {
        self.init(display: false, displayStyle: displayStyle, list: math)
    }
    
    public init(_ math: Math ...) {
        self.init(display: false, displayStyle: false, list: math)
    }
    
    public init(_ from: Math, to: Math) {
        self.init(from, .ldots, to)
    }

    public init(run math: Math ...) {
        self.init(display: false, displayStyle: false, run: math)
    }
    
    // List
    
//    public init(display: Bool, list math: Math ...) {
//        self.init(display: display, displayStyle: false, list: math)
//    }
//
//    public init(displayStyle: Bool, list math: Math ...) {
//        self.init(display: false, displayStyle: displayStyle, list: math)
//    }
    
//    public init(list math: Math ...) {
//        self.init(display: false, displayStyle: false, list: math)
//    }
    
    // Static
    
    public static func display(_ math: Math ...) -> Math {
        return Math(display: true, displayStyle: false, list: math)
    }
    
//    public static func display(list math: Math ...) -> Math {
//        return Math(display: true, displayStyle: false, list: math)
//    }
    
//    public static func list(_ math: Math ...) -> Math {
//        return Math(display: false, displayStyle: false, list: math)
//    }
    
    public static func times(_ math: Math ...) -> Math {
        return Math(display: false, displayStyle: false, times: math)
    }
}

extension Math.Precedence: Comparable {
    public static func <(lhs: Math.Precedence, rhs: Math.Precedence) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

extension Math {
    private var begin: String {
        return display ? "$$" : "$"
    }
    
    private var innerCode: String {
        return displayStyle ? "{\\displaystyle \(code)}" : code
    }
    
    private var end: String {
        return display ? "$$" : "$"
    }
}

extension Math {
    private static func bracket(_ type: Bracket, tall: Bool = false, _ math: [Math]) -> Math {
        let listMath = Math(display: false, displayStyle: false, list: math)
        let code: String
        let notTall = !tall && listMath.singleHeight
        switch type {
        case .round:
            code = notTall ? "(\(listMath.innerCode))" : "\\left(\(listMath.innerCode)\\right)"
        case .square:
            code = notTall ? "[\(listMath.innerCode)]" : "\\left[\(listMath.innerCode)\\right]"
        case .curly:
            code = notTall ? "\\{\(listMath.innerCode)\\}" : "\\left\\{\(listMath.innerCode)\\right\\}"
        case .flat:
            code = notTall ? "|\(listMath.innerCode)|" : "\\left|\(listMath.innerCode)\\right|"
        }
        return Math(display: false, displayStyle: false, precedence: .group, singleHeight: notTall, shell: (.bracket, .bracket), code: code)
    }
    
    public static func round(_ math: Math ...) -> Math {
        return bracket(.round, math)
    }
    
    public static func square(_ math: Math ...) -> Math {
        return bracket(.square, math)
    }
    
    public static func curly(_ math: Math ...) -> Math {
        return bracket(.curly, math)
    }
    
    public static func flat(_ math: Math ...) -> Math {
        return bracket(.flat, math)
    }
    
    public static func tallRound(_ math: Math ...) -> Math {
        return bracket(.round, tall: true, math)
    }
    
    public static func tallSquare(_ math: Math ...) -> Math {
        return bracket(.square, tall: true, math)
    }
    
    public static func tallCurly(_ math: Math ...) -> Math {
        return bracket(.curly, tall: true, math)
    }
}

extension Math {
    private static func group(_ math: Math, `for` precedence: Precedence) -> Math {
        let associative = precedence.associative
        return ((associative && math.precedence < precedence) || (!associative && math.precedence <= precedence)) ? .round(math) : math
    }
}

extension Math: CustomStringConvertible {
    public var description: String {
        return normalizedLiteralEncloser + begin + innerCode + end + normalizedLiteralEncloser
    }
}

extension Math: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self.init(display: false, displayStyle: false, precedence: .group, singleHeight: true, shell: (.number, .number), code: "\(value)")
    }
}

extension Math: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Float) {
        self.init(display: false, displayStyle: false, precedence: .group, singleHeight: true, shell: (.number, .number), code: "\(value)")
    }
}

extension Math: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(display: false, displayStyle: false, precedence: .group, singleHeight: true, shell: (.letter, .letter), code: forceEscape(value))
    }
}

extension Math: ExpressibleByArrayLiteral {
    public init(array: [Math]) {
        self.init(display: false, displayStyle: false, list: array)
    }
    
    public init(arrayLiteral: Math ...) {
        self.init(array: arrayLiteral)
    }
}

extension Math {
    public static func +(lhs: Math, rhs: Math) -> Math {
        let groupedLHS = Math.group(lhs, for: .addition)
        let groupedRHS = Math.group(rhs, for: .addition)
        return Math(
            display: lhs.display,
            displayStyle: false,
            precedence: .addition,
            singleHeight: lhs.singleHeight && rhs.singleHeight,
            shell: (groupedLHS.shell.left, groupedRHS.shell.right),
            code: groupedLHS.innerCode + " + " + groupedRHS.innerCode
        )
    }
    
    public static func *(lhs: Math, rhs: Math) -> Math {
        let groupedLHS = Math.group(lhs, for: .multiplication)
        let groupedRHS = Math.group(rhs, for: .multiplication)
        let times: String
        switch (groupedLHS.shell.right, groupedRHS.shell.left) {
        case (.fraction, .fraction): times = "{\\,}"
        case (.number, .number): times = "{\\times}"
        default: times = " "
        }
        return Math(
            display: lhs.display,
            displayStyle: false,
            precedence: .multiplication,
            singleHeight: lhs.singleHeight && rhs.singleHeight,
            shell: (groupedLHS.shell.left, groupedRHS.shell.right),
            code: groupedLHS.innerCode + times + groupedRHS.innerCode
        )
    }
    
    public static func /(lhs: Math, rhs: Math) -> Math {
        let groupedLHS = Math.group(lhs, for: .multiplication)
        let groupedRHS = Math.group(rhs, for: .multiplication)
        return Math(
            display: lhs.display,
            displayStyle: false,
            precedence: .multiplication,
            singleHeight: lhs.singleHeight && rhs.singleHeight,
            shell: (groupedLHS.shell.left, groupedRHS.shell.right),
            code: groupedLHS.innerCode + " / " + groupedRHS.innerCode
        )
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
            code: lhsCode + " ^ {" + rhs.innerCode + "}"
        )
    }
    
    private static func assignOrCompare(lhs: Math, rhs: Math, op: String) -> Math {
        let groupedLHS = Math.group(lhs, for: .assignment)
        let groupedRHS = Math.group(rhs, for: .assignment)
        return Math(
            display: lhs.display,
            displayStyle: false,
            precedence: .assignment,
            singleHeight: lhs.singleHeight && rhs.singleHeight,
            shell: (groupedLHS.shell.left, groupedRHS.shell.right),
            code: groupedLHS.innerCode + " " + op + " " + groupedRHS.innerCode
        )
    }
    
    public static func *=*(lhs: Math, rhs: Math) -> Math {
        return assignOrCompare(lhs: lhs, rhs: rhs, op: "=")
    }
    
    public static func <(lhs: Math, rhs: Math) -> Math {
        return assignOrCompare(lhs: lhs, rhs: rhs, op: "<")
    }
    
    public static func >(lhs: Math, rhs: Math) -> Math {
        return assignOrCompare(lhs: lhs, rhs: rhs, op: ">")
    }
    
    public static func <=(lhs: Math, rhs: Math) -> Math {
        return assignOrCompare(lhs: lhs, rhs: rhs, op: "{\\leq}")
    }
    
    public static func >=(lhs: Math, rhs: Math) -> Math {
        return assignOrCompare(lhs: lhs, rhs: rhs, op: "{\\geq}")
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
            code: "{" + groupedSelf.innerCode + "} _ {" + listRHS.innerCode + "}"
        )
    }
    
    public func sub(_ from: Math, to: Math) -> Math {
        return Math(self.sub(from), .ldots, self.sub(to))
    }
    
    public func of(_ math: Math ...) -> Math {
        return Math(run: self, Math.bracket(.round, math))
    }
    
    public func inSet(_ from: Math, to: Math) -> Math {
        return Math(run: self, .in, .curly(Math(display: false, displayStyle: false, list: [from, .ldots, to])))
    }
    
    public var abs: Math {
        return Math.abs(self)
    }
}

public extension Math {
    public static let ldots = Math(display: false, displayStyle: false, precedence: .group, singleHeight: true, shell: (.symbol, .symbol), code: "\\ldots")
    public static let comma = Math(display: false, displayStyle: false, precedence: .group, singleHeight: true, shell: (.symbol, .symbol), code: ",\\,")
    public static let times = Math(display: false, displayStyle: false, precedence: .group, singleHeight: true, shell: (.symbol, .symbol), code: "\\times")
    public static let `in` = Math(display: false, displayStyle: false, precedence: .group, singleHeight: true, shell: (.symbol, .symbol), code: "{\\in}")
    public static let det = Math(display: false, displayStyle: false, precedence: .group, singleHeight: true, shell: (.symbol, .symbol), code: "{\\det}")
    public static let sign = Math(display: false, displayStyle: false, precedence: .group, singleHeight: true, shell: (.symbol, .symbol), code: "{\\mathrm{sign}}")
    public static let sigma = Math(display: false, displayStyle: false, precedence: .group, singleHeight: true, shell: (.symbol, .symbol), code: "{\\sigma}")
}

public extension Math {
//    public static func list(_ from: Math, to: Math) -> Math {
//        return Math(from, .ldots, to)
//    }
    
    public static func times(_ from: Math, to: Math) -> Math {
        return .times(from, .ldots, to)
    }
    
    public static func set(_ math: Math ...) -> Math {
        return curly(Math(display: false, displayStyle: false, list: math))
    }
    
    public static func set(_ from: Math, to: Math) -> Math {
        return set(from, .ldots, to)
    }
    
    public static func tuple(_ math: Math ...) -> Math {
        return curly(Math(display: false, displayStyle: false, list: math))
    }
    
    public static func tuple(_ from: Math, to: Math) -> Math {
        return tuple(from, .ldots, to)
    }
    
    public static func det(_ entry: Math, `for` subs: Math? = nil) -> Math  {
        guard let subs = subs else {
            return Math(run: .det, Math.tallRound(entry))
        }
        return Math(run: .det, Math.tallRound(entry).sub(subs))
    }
    
    public static func sign(_ math: Math) -> Math  {
        return Math(run: .sign, Math.round(math))
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
    public func inSet(_ from: Math, to: Math) -> Math {
        return Math(array: self).inSet(from, to: to)
    }
}
