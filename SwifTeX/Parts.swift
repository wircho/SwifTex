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
    public let content: (DocumentType) -> Void
    public static var name: String { return PartInfo.part.rawValue }
    public let documentPrefix: String? = nil
    public let parameter: (left: EncloseParameter, right: EncloseParameter)
    public let prepare: ((Document) -> Void)? = nil
    public init(_ title: String, content: @escaping (DocumentType) -> Void) {
        parameter = (.none, .required(title))
        self.content = content
    }
}

public struct ChapterInfo: PartInfoProtocol {
    public typealias Parent = Document
    public static var part = Part.chapter
}

public struct SectionInfo: PartInfoProtocol {
    public typealias Parent = Chapter.DocumentType
    public static var part = Part.section
}

public struct SubsectionInfo: PartInfoProtocol {
    public typealias Parent = Section.DocumentType
    public static var part = Part.subsection
}

public typealias Chapter = PartStruct<ChapterInfo>
public typealias Section = PartStruct<SectionInfo>
public typealias Subsection = PartStruct<SubsectionInfo>

public func <-(lhs: Document, rhs: Section) {
    insert(into: lhs, insertable: rhs)
}
