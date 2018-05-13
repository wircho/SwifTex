//
//  Enums.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-04.
//  Copyright © 2018 Wircho. All rights reserved.
//

public enum DocumentClass: String {
    case article
}

public enum DocumentError: Error {
    case FilePathNotSpecified
}

public enum Part: String {
    case chapter
    case section
    case subsection
}

public enum Statement: String {
    case theorem
    case corollary
    case lemma
}

public enum Numbered {
    case statement(Statement)
    case part(Part)
}

extension Numbered: RawRepresentable {
    public var rawValue: String {
        switch self {
        case .statement(let statement): return statement.rawValue
        case .part(let part): return part.rawValue
        }
    }
    
    public init?(rawValue: String) {
        guard let part = Part(rawValue: rawValue) else {
            guard let numbered = Statement(rawValue: rawValue).map({ Numbered.statement($0) }) else { return nil }
            self = numbered
            return
        }
        self = .part(part)
    }
}

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

public enum EncloseParameter {
    case none
    case required(String)
    case optional(String)
}

extension EncloseParameter: CustomStringConvertible {
    public var description: String {
        switch self {
        case .none: return ""
        case .required(let value): return Bracket.curly.enclose(value)
        case .optional(let value): return Bracket.square.enclose(value)
        }
    }
}

