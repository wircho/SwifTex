//
//  EncloseInsertable.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-12.
//  Copyright © 2018 Wircho. All rights reserved.
//

public protocol EncloseInsertable: Insertable {
    var name: String { get }
}

public extension EncloseInsertable {
    public func insert(into document: Document) {
        document.enclose(name) {
            
        }
    }
}
