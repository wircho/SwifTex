//
//  Itemize.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-11.
//  Copyright © 2018 Wircho. All rights reserved.
//

public struct Itemize: EncloseInsertable {
    public let content: (EnclosedDocument<Itemize>) -> Void
    public static let name = "itemize"
    public let documentPrefix: String? = "\\item"
    public let parameter: (left: EncloseParameter, right: EncloseParameter) = (.none, .none)
    public let prepare: ((Document) -> Void)? = nil
}

public struct Item {
    public let name: String?
    public let content: (ItemDocument) -> Void
}

extension Item: Subinsertable {
    public typealias Parent = EnclosedDocument<Itemize>
    public func insert(into document: Document) {
        if let name = name { document <!- "[\(name)]" }
        content(ItemDocument(innerDocument: document))
    }
}

public struct ItemDocument: DocumentProtocol {
    public let innerDocument: Document
    public let prefix: String? = nil
}

