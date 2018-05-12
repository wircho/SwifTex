//
//  Itemize.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-11.
//  Copyright © 2018 Wircho. All rights reserved.
//

public struct Itemize {
    typealias DocumentType = ItemizeDocument
    public let content: (ItemizeDocument) -> Void
    public let name = "itemize"
}

public struct ItemizeDocument: EnclosedDocument {
    public let innerDocument: Document
    public let prefix: String? = "\\item"
}

public struct Item {
    public let name: String?
    public let content: (ItemDocument) -> Void
    public init(_ name: String? = nil, content: @escaping (ItemDocument) -> Void) {
        self.name = name
        self.content = content
    }
}

public struct ItemDocument: DocumentProtocol {
    public let innerDocument: Document
    public let prefix: String? = nil
}

extension Item: Subinsertable {
    public typealias Parent = ItemizeDocument
    public func insert(into document: Document) {
        if let name = name { document <!- "[\(name)]" }
        content(ItemDocument(innerDocument: document))
    }
}

