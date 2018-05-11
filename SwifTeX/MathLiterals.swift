//
//  MathLiterals.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-09.
//  Copyright © 2018 Wircho. All rights reserved.
//

internal extension Math.Literal {
    internal init(symbol: String) {
        self.init(code: symbol, short: true, single: true, codeEnd: (.symbol, .symbol), renderEnd: (.symbol, .symbol))
    }
    
    internal static func symbol(_ symbol: String) -> Math.Literal {
        return Math.Literal(symbol: symbol)
    }
    
    internal init(backslash: String, renderEnd: (left: Math.RenderEnd, right: Math.RenderEnd)) {
        self.init(code: "\\\(backslash)", short: true, single: true, codeEnd: (.symbol, .letter), renderEnd: renderEnd)
    }
    
    internal static func backslash(_ symbol: String, renderEnd: (left: Math.RenderEnd, right: Math.RenderEnd)) -> Math.Literal {
        return Math.Literal(backslash: symbol, renderEnd: renderEnd)
    }
    
    internal static let empty = Math.Literal(code: "", short: true, single: false, codeEnd: (.letter, .letter), renderEnd: (.letter, .letter))
    internal static let comma = Math.Literal(code: ",\\,", short: true, single: false, codeEnd: (.symbol, .symbol), renderEnd: (.symbol, .symbol))
    internal static let sign = Math.Literal(code: "\\mathrm{sign}", short: true, single: true, codeEnd: (.symbol, .symbol), renderEnd: (.prettyLetter, .prettyLetter))
    
    internal static let equals = Math.Literal.symbol("=")
    internal static let lt = Math.Literal.symbol("<")
    internal static let gt = Math.Literal.symbol(">")
    internal static let plus = Math.Literal.symbol("+")
    internal static let over = Math.Literal.symbol("/")
    internal static let minus = Math.Literal.symbol("-")
    internal static let space = Math.Literal.symbol("\\,")
    
    internal static let leq = Math.Literal.backslash("leq", renderEnd: (.symbol, .symbol))
    internal static let geq = Math.Literal.backslash("geq", renderEnd: (.symbol, .symbol))
    internal static let times = Math.Literal.backslash("times", renderEnd: (.symbol, .symbol))
    internal static let isIn = Math.Literal.backslash("in", renderEnd: (.symbol, .symbol))
    
    internal static let frac = Math.Literal.backslash("frac", renderEnd: (.fraction, .fraction))
    internal static let det = Math.Literal.backslash("det", renderEnd: (.applyingLetter, .applyingLetter))
    internal static let displayStyle = Math.Literal.backslash("displaystyle", renderEnd: (.letter, .letter))
    
    internal static let ldots = Math.Literal.backslash("ldots", renderEnd: (.symbol, .symbol))
    internal static let cdots = Math.Literal.backslash("cdots", renderEnd: (.symbol, .symbol))
    
    internal static let sigma = Math.Literal.backslash("sigma", renderEnd: (.symbol, .symbol))
    
    internal static let cdotsInSpaces = Math.Literal(code: join(Math.Literal.space, Math.Literal.cdots, Math.Literal.space), short: true, single: false, codeEnd: (.symbol, .symbol), renderEnd: (.symbol, .symbol))
    internal static let timesInSpaces = Math.Literal(code: join(Math.Literal.space, Math.Literal.times, Math.Literal.space), short: true, single: false, codeEnd: (.symbol, .symbol), renderEnd: (.symbol, .symbol))
    internal static let cdotsInTimes = Math.Literal(code: join(Math.Literal.timesInSpaces, Math.Literal.cdots, Math.Literal.timesInSpaces), short: true, single: false, codeEnd: (.symbol, .symbol), renderEnd: (.symbol, .symbol))
    
    
    internal static let sum = Math.Literal(code: "\\sum", short: false, single: true, codeEnd: (.symbol, .letter), renderEnd: (.symbol, .symbol))
    
    internal static let toThe = Math.Literal.symbol("^")
    internal static let sub = Math.Literal.symbol("_")
}

public extension Math {
    public static let ldots = Math(content: .literal(.ldots))
    public static let det = Math(content: .literal(.det))
    public static let sign = Math(content: .literal(.sign))
    public static let sigma = Math(content: .literal(.sigma))
}
