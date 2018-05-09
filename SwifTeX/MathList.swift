//
//  MathList.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-09.
//  Copyright © 2018 Wircho. All rights reserved.
//

internal extension Math {
    internal init(display: Bool? = nil, displayStyle: Bool = false, list math: [Math]) {
        if math.count <= 1 {
            self.init(display: display, displayStyle: displayStyle, precedence: math.first?.precedence ?? .group, concat: math)
            return
        }
        var commaMath = math
        for i in 0 ..< math.count - 1 {
            commaMath.insert(.comma, at: 2 * i + 1)
        }
        self.init(display: display, displayStyle: displayStyle, precedence: .list, concat: commaMath)
    }
}

public extension Math {
    
    public init(display: Bool? = nil, displayStyle: Bool = false, _ math: Math ...) {
        self.init(display: display, displayStyle: displayStyle, list: math)
    }
    
    public static func display(_ math: Math ...) -> Math {
        return Math(display: true, list: math)
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
