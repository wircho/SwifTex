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

internal extension Document {
    fileprivate func setStatementHeader(_ type: StatementType, overwrite: Bool, name: String? = nil, sibling: StatementType? = nil, parent: NumberedType? = nil) {
        guard let index = statementHeaders.index(where: { $0.type == type }) else {
            statementHeaders.append(StatementHeader(type: type, name: name, sibling: sibling, parent: parent))
            return
        }
        guard overwrite else { return }
        statementHeaders[index] = StatementHeader(type: type, name: name, sibling: sibling, parent: parent)
    }
    
    fileprivate func setDefaultStatementHeader(_ type: StatementType, overwrite: Bool) {
        switch type {
        case .theorem: setStatementHeader(type, overwrite: overwrite)
        case .corollary: setStatementHeader(type, overwrite: overwrite, parent: .statement(.theorem))
        case .lemma: setStatementHeader(type, overwrite: overwrite)
        }
    }
    
    fileprivate func statement(_ type: StatementType, title: String?, closure: (Document) -> Void) {
        setDefaultStatementHeader(type, overwrite: false)
        enclose(type.rawValue, parameter: title.map { (.none, .optional($0)) } ?? (.none, .none), closure: closure)
    }
}

public extension DocumentProtocol {
    public func theoremHeader(name: String? = nil, sibling: StatementType? = nil, parent: NumberedType? = nil) {
        innerDocument.setStatementHeader(.theorem, overwrite: true, name: name, sibling: sibling, parent: parent)
    }
    public func corollaryHeader(name: String? = nil, sibling: StatementType? = nil, parent: NumberedType? = nil) {
        innerDocument.setStatementHeader(.corollary, overwrite: true, name: name, sibling: sibling, parent: parent)
    }
    public func lemmaHeader(name: String? = nil, sibling: StatementType? = nil, parent: NumberedType? = nil) {
        innerDocument.setStatementHeader(.lemma, overwrite: true, name: name, sibling: sibling, parent: parent)
    }
    
    public func theorem(_ title: String? = nil, closure: (Document) -> Void) { innerDocument.statement(.theorem, title: title, closure: closure) }
    public func corollary(_ title: String? = nil, closure: (Document) -> Void) { innerDocument.statement(.corollary, title: title, closure: closure) }
    public func lemma(_ title: String? = nil, closure: (Document) -> Void) { innerDocument.statement(.lemma, title: title, closure: closure) }
    
    public func theorem(_ title: String? = nil, _ statement: String) { theorem(title, closure: { $0 <- statement }) }
    public func corollary(_ title: String? = nil, _ statement: String) { corollary(title, closure: { $0 <- statement }) }
    public func lemma(_ title: String? = nil, _ statement: String) { lemma(title, closure: { $0 <- statement }) }
    
}

public extension DocumentProtocol {
    public func proof(closure: (Document) -> Void) {
        innerDocument.enclose("proof", closure: closure)
    }
}
