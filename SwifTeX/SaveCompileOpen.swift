//
//  SaveCompile.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-04.
//  Copyright © 2018 Wircho. All rights reserved.
//

import AppKit

public extension Document {
    public struct Saved {
        fileprivate let path: String
    }
    public struct Compiled {
        fileprivate let texPath: String
        fileprivate let pdfPath: String
    }
}

extension Document {
    public func save() throws -> Saved {
        guard let path = path else { throw DocumentError.FilePathNotSpecified }
        return try save(at: path)
    }
    
    public func save(at path: String) throws -> Saved {
        try self.content.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
        return Saved(path: path)
    }
}

public extension Document.Saved {
    private var pdfPath: String {
        return URL(fileURLWithPath: path).deletingPathExtension().appendingPathExtension("pdf").path
    }
    
    private var folderPath: String {
        return URL(fileURLWithPath: path).deletingLastPathComponent().path
    }
    
    public func compile() throws -> Document.Compiled {
        let task = Process()
        task.launchPath = "/Library/TeX/texbin/pdflatex"
        task.arguments = ["-output-directory", folderPath, path]
        task.launch()
        task.waitUntilExit()
        print("Compile task ended: \(task.terminationStatus)")
        return Document.Compiled(texPath: path, pdfPath: pdfPath)
    }
}

public extension Document.Compiled {
    public func open() {
        NSWorkspace.shared.openFile(pdfPath)
    }
}
