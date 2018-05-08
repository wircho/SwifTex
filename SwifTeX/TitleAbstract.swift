//
//  TitleAbstract.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-06.
//  Copyright © 2018 Wircho. All rights reserved.
//

public extension Document {
    public func title(_ title: String, author: String? = nil) {
        headers.insert("\\title\(Bracket.curly.escape(title))")
        guard let author = author else { return }
        headers.insert("\\author\(Bracket.curly.escape(author))")
        self <!- "\\maketitle\n"
    }
    
    public func abstract(_ abstract: String) {
        enclose("abstract") {
            $0 <- abstract
        }
    }
}
