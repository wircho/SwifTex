//
//  Inserting.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-04.
//  Copyright © 2018 Wircho. All rights reserved.
//

infix operator <-: AssignmentPrecedence
infix operator <!-: AssignmentPrecedence

public protocol DocumentProtocol {
    var innerDocument: Document { get }
    var prefix: String? { get }
}
extension Document: DocumentProtocol {
    public var innerDocument: Document { return self }
    public var prefix: String? { return nil }
}

public protocol InsertableBase {
    func insert(into document: Document)
}

public protocol Insertable: InsertableBase { }

extension String: Insertable {
    public func insert(into document: Document) { document.innerContent += " " + escape(self) }
}

public func <!-(document: Document, string: String) {
    document.innerContent += string
}

public func <-<T: Insertable>(document: DocumentProtocol, insertable: T) {
    insert(into: document, insertable: insertable)
}

internal func insert<T: InsertableBase>(into document: DocumentProtocol, insertable: T) {
    if let prefix = document.prefix { document.innerDocument.innerContent += prefix }
    insertable.insert(into: document.innerDocument)
}
