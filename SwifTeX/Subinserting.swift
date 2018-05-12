//
//  Subinserting.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-12.
//  Copyright © 2018 Wircho. All rights reserved.
//

public protocol Subinsertable: InsertableBase {
    associatedtype Parent: DocumentProtocol
}

public func <-<T: Subinsertable>(document: T.Parent, insertable: T) {
    // TODO: ABSTRACT BOTH <- OUT
    if let prefix = document.prefix { document.innerDocument.innerContent += prefix }
    insertable.insert(into: document.innerDocument)
}
