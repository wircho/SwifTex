//
//  TikzPath.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-21.
//  Copyright © 2018 Wircho. All rights reserved.
//

public struct TikzPath {
    public var style: TikzStyle
    public var items: [AnyTikzItem]
    
    public init(style: TikzStyle = .none, _ items: [AnyTikzItem]) {
        self.style = style
        self.items = items
    }
}

public extension TikzPath {
    public init(style: TikzStyle = .none, _ items: AnyTikzItem ...) {
        self.init(style: style, items)
    }
}

extension TikzPath: TikzElement {
    public var elementCode: String {
        return style.drawPrefix(for: self) + " " + items.map{ $0.description }.joined(separator: " -- ") + ";"
    }
}
