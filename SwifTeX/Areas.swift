//
//  Areas.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-05.
//  Copyright © 2018 Wircho. All rights reserved.
//

private extension Document {
    private func area(_ type: AreaType, title: String, closure: (Document) -> Void) {
        enclose(type.rawValue, requiredTitle: title, closure: closure)
    }
}

public extension Document {
    public func chapter(_ title: String, closure: (Document) -> Void) { area(.chapter, title: title, closure: closure) }
    public func section(_ title: String, closure: (Document) -> Void) { area(.section, title: title, closure: closure) }
    public func subsection(_ title: String, closure: (Document) -> Void) { area(.subsection, title: title, closure: closure) }
}
