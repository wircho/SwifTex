//
//  MathSymbols.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-09.
//  Copyright © 2018 Wircho. All rights reserved.
//

public extension Math {
    internal static func symbol(_ code: String) -> Math {
        return Math(precedence: .group, singleHeight: true, shell: (.symbol, .symbol), code: code)
    }
    
    public static let equals = Math.symbol("=")
    public static let lt = Math.symbol("<")
    public static let gt = Math.symbol(">")
    public static let leq = Math.symbol("\\leq ")
    public static let geq = Math.symbol("\\geq ")
    public static let ldots = Math.symbol("\\ldots ")
    public static let cdots = Math.symbol("\\cdots ")
    public static let comma = Math.symbol(",\\,")
    public static let space = Math.symbol("\\,")
    public static let nothing = Math.symbol("")
    public static let times = Math.symbol("\\times ")
    public static let `in` = Math.symbol("\\in ")
    public static let det = Math.symbol("\\det ")
    public static let sign = Math.symbol("\\mathrm{sign}")
    public static let sigma = Math.symbol("\\sigma ")
    public static let plus = Math.symbol("+")
    public static let over = Math.symbol("/")
    public static let minus = Math.symbol("-")
    public static let toThe = Math.symbol("^")
}
