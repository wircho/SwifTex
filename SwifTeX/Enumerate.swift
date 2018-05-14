//
//  Enumerate.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-12.
//  Copyright © 2018 Wircho. All rights reserved.
//

public struct Enumerate: EncloseInsertable {
    public let content: (EnclosedDocument<Enumerate>) -> Void
    public static let name = "enumerate"
    public let documentPrefix = "\\item"
    public let parameter: (left: EncloseParameter, right: EncloseParameter) = (.none, .none)
    public let prepare: ((Document) -> Void)? = nil
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
