//
//  MathList.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-09.
//  Copyright © 2018 Wircho. All rights reserved.
//

internal extension Math {
    internal init(display optionalDisplay: Bool? = nil, displayStyle: Bool = false, list maths: [Math]) {
        let display = optionalDisplay ?? maths.first?.display ?? false
        guard maths.count > 0 else {
            self.init(display: display, displayStyle: displayStyle, content: .literal(.empty))
            return
        }
        var mutableMaths = maths
        let last = mutableMaths.removeLast()
        guard mutableMaths.count > 0 else {
            self.init(display: display, displayStyle: displayStyle, content: last.content)
            return
        }
        self.init(display: display, displayStyle: displayStyle, content: .operation(.other(.comma), lhs: Math(list: mutableMaths).content, rhs: last.content))
    }
}

public extension Math {
    
    public init(display: Bool? = nil, displayStyle: Bool = false, _ math: Math ...) {
        self.init(display: display, displayStyle: displayStyle, list: math)
    }
    
    public static func display(_ math: Math ...) -> Math {
        return Math(display: true, list: math)
    }
    
    public static func displayStyle(_ math: Math ...) -> Math {
        return Math(displayStyle: true, list: math)
    }
}

public extension Math {
    
    public init(display: Bool? = nil, displayStyle: Bool = false, _ from: Math, to: Math) {
        self.init(display: display, displayStyle: displayStyle, from, .ldots, to)
    }
    
    public static func from(_ from: Math, to: Math) -> Math {
        return Math(from, to: to)
    }
}
