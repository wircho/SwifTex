//
//  EncloseInsertable.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-12.
//  Copyright © 2018 Wircho. All rights reserved.
//

public protocol EncloseInsertableBase: InsertableBase {
    associatedtype Specifier
    static var name: String { get }
    var content: (EnclosedDocument<Specifier>) -> Void { get }
    var documentPrefix: String? { get }
    var parameter: (left: EncloseParameter, right: EncloseParameter) { get }
    var prepare: ((Document) -> Void)? { get }
}

public struct EnclosedDocument<Specifier>: DocumentProtocol {
    public let innerDocument: Document
    public let prefix: String?
    public init(innerDocument: Document, prefix: String? = nil) {
        self.innerDocument = innerDocument
        self.prefix = prefix
    }
}

public extension EncloseInsertableBase {
    public func insert(into document: Document) {
        prepare?(document)
        document.enclose(Self.name, parameter: parameter) {
            content(EnclosedDocument<Specifier>(innerDocument: $0, prefix: documentPrefix))
        }
    }
}

public protocol EncloseInsertable: EncloseInsertableBase, Insertable { }
public protocol EncloseSubinsertable: EncloseInsertableBase, Subinsertable { }
