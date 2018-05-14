//
//  Statements.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-05.
//  Copyright © 2018 Wircho. All rights reserved.
//

public protocol StatementInfoProtocol {
    static var statement: Statement { get }
}

public struct StatementStruct<StatementInfo: StatementInfoProtocol>: EncloseInsertable {
    public let content: (EnclosedDocument<StatementInfo>) -> Void
    public static var name: String { return StatementInfo.statement.rawValue }
    public let documentPrefix: String? = nil
    public let parameter: (left: EncloseParameter, right: EncloseParameter)
    public let prepare: ((Document) -> Void)? = { $0.setDefaultStatementHeader(StatementInfo.statement, overwrite: false) }
    public init(_ title: String, content: @escaping (StatementDocument<StatementInfo>) -> Void) {
        parameter = (.none, .optional(title))
        self.content = content
    }
}

public struct TheoremInfo: StatementInfoProtocol { public static let statement = Statement.theorem }
public struct CorollaryInfo: StatementInfoProtocol { public static let statement = Statement.corollary }
public struct LemmaInfo: StatementInfoProtocol { public static let statement = Statement.lemma }

public typealias Theorem = StatementStruct<TheoremInfo>
public typealias Corollary = StatementStruct<CorollaryInfo>
public typealias Lemma = StatementStruct<LemmaInfo>


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

// TODO: Replace with Document-only StatementHeader types
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
}

public struct Proof: EncloseInsertable {
    public let content: (ProofDocument) -> Void
    public static let name = "proof"
    public let parameter: (left: EncloseParameter, right: EncloseParameter)
    public let prepare: ((Document) -> Void)? = nil
    public init(_ title: String, content: @escaping (ProofDocument) -> Void) {
        parameter = (.none, .optional(title))
        self.content = content
    }
}
