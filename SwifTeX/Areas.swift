//
//  Areas.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-05.
//  Copyright © 2018 Wircho. All rights reserved.
//

public protocol AreaTypeProtocol {
    associatedtype Parent: DocumentProtocol
    static var kind: AreaType { get }
}

public struct Area<T: AreaTypeProtocol>: EncloseSubinsertable {
    public typealias Parent = T.Parent
    public var content: (AreaDocument<T>) -> Void
    public static var name: String { return T.kind.rawValue }
    public let parameter: (left: EncloseParameter, right: EncloseParameter)
    public init(_ title: String, content: @escaping (AreaDocument<T>) -> Void) {
        parameter = (.none, .required(title))
        self.content = content
    }
}

public struct AreaDocument<T: AreaTypeProtocol>: EnclosedDocument {
    public let innerDocument: Document
    public let prefix: String? = nil
    public init(innerDocument: Document) { self.innerDocument = innerDocument }
}

public struct ChapterType: AreaTypeProtocol {
    public typealias Parent = Document
    public static var kind = AreaType.chapter
}

public struct SectionType: AreaTypeProtocol {
    public typealias Parent = AreaDocument<ChapterType>
    public static var kind = AreaType.section
}

public struct SubsectionType: AreaTypeProtocol {
    public typealias Parent = AreaDocument<SectionType>
    public static var kind = AreaType.subsection
}

public typealias Chapter = Area<ChapterType>
public typealias Section = Area<SectionType>
public typealias Subsection = Area<SubsectionType>

public func <-(lhs: Document, rhs: Section) {
    insert(into: lhs, insertable: rhs)
}
