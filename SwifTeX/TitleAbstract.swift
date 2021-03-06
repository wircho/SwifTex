//
//  TitleAbstract.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-06.
//  Copyright © 2018 Wircho. All rights reserved.
//

public struct Title: Subinsertable {
    public typealias Parent = Document
    public let title: String
    public let author: String?
    
    public init(_ title: String, author: String? = nil) {
        self.title = title
        self.author = author
    }
    
    public func insert(into document: Document) {
        document.headers.insert("\\title\(Bracket.curly.escape(title))")
        guard let author = author else { return }
        document.headers.insert("\\author\(Bracket.curly.escape(author))")
        document <!- "\\maketitle\n"
    }
}

public struct Abstract: EncloseSubinsertable {
    public typealias Parent = Document
    public let content: (EnclosedDocument<Abstract>) -> Void
    public static let name = "abstract"
    public let documentPrefix: String? = nil
    public var parameter: (left: EncloseParameter, right: EncloseParameter) { return (.none, .none) }
    public let prepare: ((Document) -> Void)? = nil
}

public extension Abstract {
    public init(_ text: String) {
        self.init {
            $0 <- text
        }
    }
}
