//
//  EncloseInsertable.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-12.
//  Copyright © 2018 Wircho. All rights reserved.
//

public protocol EncloseInsertable: Insertable {
    associatedtype DocumentType: EnclosedDocument
    static var name: String { get }
    var content: (DocumentType) -> Void { get }
}

public protocol EnclosedDocument: DocumentProtocol {
    init(innerDocument: Document)
}

public extension EncloseInsertable {
    public func insert(into document: Document) {
        document.enclose(Self.name) {
            content(Self.DocumentType(innerDocument: $0))
        }
    }
}
