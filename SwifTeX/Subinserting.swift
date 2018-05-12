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
    insert(into: document, insertable: insertable)
}
