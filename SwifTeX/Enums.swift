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

public enum AreaType: String {
    case chapter
    case section
    case subsection
}

public enum StatementType: String {
    case theorem
    case corollary
    case lemma
}

public enum NumberedType {
    case statement(StatementType)
    case area(AreaType)
}

extension NumberedType: RawRepresentable {
    public var rawValue: String {
        switch self {
        case .statement(let statement): return statement.rawValue
        case .area(let area): return area.rawValue
        }
    }
    
    public init?(rawValue: String) {
        guard let area = AreaType(rawValue: rawValue) else {
            guard let numbered = StatementType(rawValue: rawValue).map({ NumberedType.statement($0) }) else { return nil }
            self = numbered
            return
        }
        self = .area(area)
    }
}
