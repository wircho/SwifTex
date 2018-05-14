//
//  Math.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-07.
//  Copyright © 2018 Wircho. All rights reserved.
//

internal protocol MathCodable {
    var code: String { get }
    var codeEnd: (left: Math.CodeEnd, right: Math.CodeEnd) { get }
    var renderEnd: (left: Math.RenderEnd, right: Math.RenderEnd) { get }
}

public struct Math {
    
    internal enum Operation {
        case sum
        case subtraction
        case multiplication(Literal?)
        case over
        case fraction
        case of
        case loop
        case sub
        case toThe
        case other(Literal?)
    }
    
    internal indirect enum InnerContent {
        case prefix(Literal, inner: Math.Content)
        case postfix(Literal, inner: Math.Content)
        case operation(Operation, lhs: Math.Content, rhs: Math.Content)
        case bracket(Bracket, tall: Bool, inner: Math.Content)
        case literal(Literal)
    }
    
    internal enum ContentShell {
        case grouped
        case displayStyle
        case none
    }
    
    internal struct Content {
        let inner: InnerContent
        let shell: ContentShell
    }
    
    internal enum CodeEnd {
        case number
        case letter
        case symbol
    }
    
    internal enum RenderEnd {
        case number
        case letter
        case symbol
        case applyingLetter
        case prettyLetter
        case fraction
    }
    
    internal struct Literal: MathCodable {
        let code: String
        let short: Bool
        let single: Bool
        let codeEnd: (left: CodeEnd, right: CodeEnd)
        let renderEnd: (left: RenderEnd, right: RenderEnd)
    }
    
    internal let display: Bool
    
    internal let content: Content
    
    internal init(display: Bool = false, displayStyle: Bool = false, content: Content) {
        self.display = display
        self.content = displayStyle ? Content(inner: content.inner, shell: .displayStyle) : content
    }
}
