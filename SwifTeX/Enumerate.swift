//
//  Enumerate.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-12.
//  Copyright © 2018 Wircho. All rights reserved.
//

public struct Enumerate {
    internal let content: (EnumerateDocument) -> Void
}

public struct EnumerateDocument: DocumentProtocol {
    public let innerDocument: Document
    public let prefix: String? = "\\item"
}

extension Enumerate: Insertable {
    public func insert(into document: Document) {
        document.enclose("enumerate") {
            content(EnumerateDocument(innerDocument: $0))
        }
    }
}

public struct Number {
    public let content: (NumberDocument) -> Void
    public init(content: @escaping (NumberDocument) -> Void) {
        self.content = content
    }
}

public struct NumberDocument: DocumentProtocol {
    public let innerDocument: Document
    public let prefix: String? = nil
}

extension Number: Subinsertable {
    public typealias Parent = EnumerateDocument
    public func insert(into document: Document) {
        content(NumberDocument(innerDocument: document))
    }
}
