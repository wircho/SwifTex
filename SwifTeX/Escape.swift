//
//  Escape.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-04.
//  Copyright © 2018 Wircho. All rights reserved.
//

import Cocoa

private let literalEncloser = "@@@"
private let literalRegex = try! NSRegularExpression(pattern: "(\n|^)[ \\t\\f\\r]*" + literalEncloser + "[ \\t\\f\\r]*(\n|$)")
private let normalizedLiteralEncloser = "\n" + literalEncloser + "\n"

internal func forceEscape(_ text: String) -> String {
    return text.replacingOccurrences(of: "\\", with: "\\\\")
        .replacingOccurrences(of: "{", with: "\\{")
        .replacingOccurrences(of: "}", with: "\\}")
        .replacingOccurrences(of: "$", with: "\\$")
}

internal func escape(_ text: String) -> String {
    let parts = literalRegex.stringByReplacingMatches(in: text, options: [], range: NSMakeRange(0, (text as NSString).length), withTemplate: normalizedLiteralEncloser).components(separatedBy: normalizedLiteralEncloser)
    return parts.enumerated().map { (i, str) -> String in (i % 2 == 0) ? forceEscape(str) : str }.joined(separator: "")
}

internal func literal(_ text: String) -> String {
    return normalizedLiteralEncloser + text + normalizedLiteralEncloser
}

private let globalEscape = escape

internal extension Bracket {
    func escape(_ string: String?) -> String {
        guard let string = string else { return "" }
        return enclose(globalEscape(string))
    }
}
