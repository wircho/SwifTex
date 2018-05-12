//
//  Itemize.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-11.
//  Copyright © 2018 Wircho. All rights reserved.
//

public struct Itemize: EncloseInsertable {
    public let content: (ItemizeDocument) -> Void
    public static let name = "itemize"
}

public struct ItemizeDocument: EnclosedDocument {
    public let innerDocument: Document
    public let prefix: String? = "\\item"
    public init(innerDocument: Document) { self.innerDocument = innerDocument }
}

public struct Item {
    public let name: String?
    public let content: (ItemDocument) -> Void
}

extension Item: Subinsertable {
    public typealias Parent = ItemizeDocument
    public func insert(into document: Document) {
        if let name = name { document <!- "[\(name)]" }
        content(ItemDocument(innerDocument: document))
    }
}

public struct ItemDocument: DocumentProtocol {
    public let innerDocument: Document
    public let prefix: String? = nil
}

