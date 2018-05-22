//
//  Document.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-03.
//  Copyright © 2018 Wircho. All rights reserved.
//

// MARK: - Document

public class Document {
    public typealias Class = DocumentClass
    
    public let `class`: Class
    public let path: String?
    
    //TODO: Add a prepare method to StringConvertible
    internal var headers: Set<String> = ["\\usepackage{amsthm}", "\\usepackage{tikz}"]
    internal var statementHeaders: [StatementHeader] = []
    
    public internal(set) var innerContent = ""
    
    public init(_ `class`: Class, at path: String? = nil) {
        self.class = `class`
        self.path = path
    }
}

// MARK: - Content

public extension Document {
    public var content: String {
        return """
        \\documentclass{\(self.class.rawValue)}
        \(headers.joined(separator: "\n"))
        \(statementHeaders.map{ $0.definition }.joined(separator: "\n"))
        \\begin{document}
        \(self.innerContent)
        \\end{document}
        """
    }
}

