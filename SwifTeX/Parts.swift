//
//  Parts.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-05.
//  Copyright © 2018 Wircho. All rights reserved.
//

public protocol PartInfoProtocol {
    associatedtype Parent: DocumentProtocol
    static var part: Part { get }
}

public struct PartStruct<PartInfo: PartInfoProtocol>: EncloseSubinsertable {
    public typealias Parent = PartInfo.Parent
    public let content: (PartDocument<PartInfo>) -> Void
    public static var name: String { return PartInfo.part.rawValue }
    public let parameter: (left: EncloseParameter, right: EncloseParameter)
    public let prepare: ((Document) -> Void)? = nil
    public init(_ title: String, content: @escaping (PartDocument<PartInfo>) -> Void) {
        parameter = (.none, .required(title))
        self.content = content
    }
}

public struct PartDocument<PartInfo: PartInfoProtocol>: EnclosedDocument {
    public let innerDocument: Document
    public let prefix: String? = nil
    public init(innerDocument: Document) { self.innerDocument = innerDocument }
}

public struct ChapterInfo: PartInfoProtocol {
    public typealias Parent = Document
    public static var part = Part.chapter
}

public struct SectionInfo: PartInfoProtocol {
    public typealias Parent = PartDocument<ChapterInfo>
    public static var part = Part.section
}

public struct SubsectionInfo: PartInfoProtocol {
    public typealias Parent = PartDocument<SectionInfo>
    public static var part = Part.subsection
}

public typealias Chapter = PartStruct<ChapterInfo>
public typealias Section = PartStruct<SectionInfo>
public typealias Subsection = PartStruct<SubsectionInfo>

public func <-(lhs: Document, rhs: Section) {
    insert(into: lhs, insertable: rhs)
}
