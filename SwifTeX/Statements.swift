//
//  Statements.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-05.
//  Copyright © 2018 Wircho. All rights reserved.
//

internal struct StatementHeader {
    let type: StatementType
    let name: String
    let sibling: StatementType?
    let parent: NumberedType?
    
    init (type: StatementType, name: String?, sibling: StatementType?, parent: NumberedType?) {
        self.type = type
        self.name = name ?? type.rawValue.capitalized
        self.sibling = sibling
        self.parent = parent
    }
    
    var definition: String {
        return "\\newtheorem\(Bracket.curly.escape(type.rawValue))\(Bracket.square.escape(sibling?.rawValue))\(Bracket.curly.escape(name))\(Bracket.square.escape(parent?.rawValue))"
    }
}

private extension Document {
    private func setStatementHeader(_ type: StatementType, overwrite: Bool, name: String? = nil, sibling: StatementType? = nil, parent: NumberedType? = nil) {
        guard let index = statementHeaders.index(where: { $0.type == type }) else {
            statementHeaders.append(StatementHeader(type: type, name: name, sibling: sibling, parent: parent))
            return
        }
        guard overwrite else { return }
        statementHeaders[index] = StatementHeader(type: type, name: name, sibling: sibling, parent: parent)
    }
    
    private func setDefaultStatementHeader(_ type: StatementType, overwrite: Bool) {
        switch type {
        case .theorem: setStatementHeader(type, overwrite: overwrite)
        case .corollary: setStatementHeader(type, overwrite: overwrite, parent: .statement(.theorem))
        case .lemma: setStatementHeader(type, overwrite: overwrite)
        }
    }
    
    private func statement(_ type: StatementType, title: String?, closure: (Document) -> Void) {
        setDefaultStatementHeader(type, overwrite: false)
        enclose(type.rawValue, optionalTitle: title, closure: closure)
    }
}

public extension Document {
    public func theoremHeader(name: String? = nil, sibling: StatementType? = nil, parent: NumberedType? = nil) {
        setStatementHeader(.theorem, overwrite: true, name: name, sibling: sibling, parent: parent)
    }
    public func corollaryHeader(name: String? = nil, sibling: StatementType? = nil, parent: NumberedType? = nil) {
        setStatementHeader(.corollary, overwrite: true, name: name, sibling: sibling, parent: parent)
    }
    public func lemmaHeader(name: String? = nil, sibling: StatementType? = nil, parent: NumberedType? = nil) {
        setStatementHeader(.lemma, overwrite: true, name: name, sibling: sibling, parent: parent)
    }
    
    public func theorem(_ title: String? = nil, closure: (Document) -> Void) { statement(.theorem, title: title, closure: closure) }
    public func corollary(_ title: String? = nil, closure: (Document) -> Void) { statement(.corollary, title: title, closure: closure) }
    public func lemma(_ title: String? = nil, closure: (Document) -> Void) { statement(.lemma, title: title, closure: closure) }
    
    public func theorem(_ title: String? = nil, _ statement: String) { theorem(title, closure: { $0 <- statement }) }
    public func corollary(_ title: String? = nil, _ statement: String) { corollary(title, closure: { $0 <- statement }) }
    public func lemma(_ title: String? = nil, _ statement: String) { lemma(title, closure: { $0 <- statement }) }
    
}

public extension Document {
    public func proof(closure: (Document) -> Void) {
        enclose("proof", closure: closure)
    }
}
