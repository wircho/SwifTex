//
//  EncloseInsertable.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-12.
//  Copyright © 2018 Wircho. All rights reserved.
//

public protocol EncloseInsertableBase: InsertableBase {
    associatedtype DocumentType: EnclosedDocument
    static var name: String { get }
    var content: (DocumentType) -> Void { get }
    var parameter: (left: EncloseParameter, right: EncloseParameter) { get }
}

public protocol EnclosedDocument: DocumentProtocol {
    init(innerDocument: Document)
}

public extension EncloseInsertableBase {
    public func insert(into document: Document) {
        document.enclose(Self.name, parameter: parameter) {
            content(Self.DocumentType(innerDocument: $0))
        }
    }
}

public protocol EncloseInsertable: EncloseInsertableBase, Insertable { }
public protocol EncloseSubinsertable: EncloseInsertableBase, Subinsertable { }
