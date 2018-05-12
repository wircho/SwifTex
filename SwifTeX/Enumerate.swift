//
//  Enumerate.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-12.
//  Copyright © 2018 Wircho. All rights reserved.
//

public struct Enumerate: EncloseInsertable {
    public let content: (EnumerateDocument) -> Void
    public static let name = "enumerate"
}

public struct EnumerateDocument: EnclosedDocument {
    public let innerDocument: Document
    public let prefix: String? = "\\item"
    public init(innerDocument: Document) { self.innerDocument = innerDocument }
}

public struct Number {
    public let content: (NumberDocument) -> Void
}

extension Number: Subinsertable {
    public typealias Parent = EnumerateDocument
    public func insert(into document: Document) {
        content(NumberDocument(innerDocument: document))
    }
}

public struct NumberDocument: DocumentProtocol {
    public let innerDocument: Document
    public let prefix: String? = nil
}
