//
//  Statements.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-05.
//  Copyright © 2018 Wircho. All rights reserved.
//

internal struct StatementHeader {
    let statement: Statement
    let name: String
    let sibling: Statement?
    let parent: Numbered?
    
    init (statement: Statement, name: String?, sibling: Statement?, parent: Numbered?) {
        self.statement = statement
        self.name = name ?? statement.rawValue.capitalized
        self.sibling = sibling
        self.parent = parent
    }
    
    var definition: String {
        return "\\newtheorem\(Bracket.curly.escape(statement.rawValue))\(Bracket.square.escape(sibling?.rawValue))\(Bracket.curly.escape(name))\(Bracket.square.escape(parent?.rawValue))"
    }
}

internal extension Document {
    fileprivate func setStatementHeader(_ statement: Statement, overwrite: Bool, name: String? = nil, sibling: Statement? = nil, parent: Numbered? = nil) {
        guard let index = statementHeaders.index(where: { $0.statement == statement }) else {
            statementHeaders.append(StatementHeader(statement: statement, name: name, sibling: sibling, parent: parent))
            return
        }
        guard overwrite else { return }
        statementHeaders[index] = StatementHeader(statement: statement, name: name, sibling: sibling, parent: parent)
    }
    
    fileprivate func setDefaultStatementHeader(_ statement: Statement, overwrite: Bool) {
        switch statement {
        case .theorem: setStatementHeader(statement, overwrite: overwrite)
        case .corollary: setStatementHeader(statement, overwrite: overwrite, parent: .statement(.theorem))
        case .lemma: setStatementHeader(statement, overwrite: overwrite)
        }
    }
    
    fileprivate func statement(_ statement: Statement, title: String?, closure: (Document) -> Void) {
        setDefaultStatementHeader(statement, overwrite: false)
        enclose(statement.rawValue, parameter: title.map { (.none, .optional($0)) } ?? (.none, .none), closure: closure)
    }
}

public extension DocumentProtocol {
    public func theoremHeader(name: String? = nil, sibling: Statement? = nil, parent: Numbered? = nil) {
        innerDocument.setStatementHeader(.theorem, overwrite: true, name: name, sibling: sibling, parent: parent)
    }
    public func corollaryHeader(name: String? = nil, sibling: Statement? = nil, parent: Numbered? = nil) {
        innerDocument.setStatementHeader(.corollary, overwrite: true, name: name, sibling: sibling, parent: parent)
    }
    public func lemmaHeader(name: String? = nil, sibling: Statement? = nil, parent: Numbered? = nil) {
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
