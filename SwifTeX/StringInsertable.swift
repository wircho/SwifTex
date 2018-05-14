//
//  StringInsertable.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-14.
//  Copyright © 2018 Wircho. All rights reserved.
//

public protocol StringInsertable: CustomStringConvertible, Insertable { }

extension StringInsertable {
    public func insert(into document: Document) {
        document <- description
    }
}
