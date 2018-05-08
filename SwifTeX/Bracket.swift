//
//  Bracket.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-04.
//  Copyright © 2018 Wircho. All rights reserved.
//


public enum Bracket {
    case curly
    case square
    case round
    case flat
}

internal extension Bracket {
    internal func enclose(_ string: String) -> String {
        switch self {
        case .curly: return "{\(string)}"
        case .square: return "[\(string)]"
        case .round: return "(\(string))"
        case .flat: return "|\(string)|"
        }
    }
}
