//
//  MathMethods.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-10.
//  Copyright © 2018 Wircho. All rights reserved.
//

public extension Math {
    internal func sub(math: Math) -> Math {
        return Math(display: display, content: Math.Content(inner: .operation(.sub, lhs: content.asSubscriptBase, rhs: math.content.asSingleOrGrouped), shell: .none))
    }
    
    public func sub(_ math: Math ...) -> Math {
        return sub(math: Math(list: math))
    }
    
    public func sub(_ from: Math, to: Math) -> Math {
        return Math(sub(math: from), to: sub(math: to))
    }
    
    public func sub(_ from: Math, timesTo to: Math) -> Math {
        return sub(math: from) **…** sub(math: to)
    }
}

public extension Math {
    private func of(math: Math) -> Math {
        let f = content.asFunction
        return Math(display: display, content: Math.Content(inner: .operation(.of, lhs: f, rhs: math.content.asFunctionArgument(of: f)), shell: .none))
    }
    
    public func of(_ math: Math ...) -> Math {
        return of(math: Math(list: math))
    }
}

public extension Math {
    public func isIn(_ math: Math) -> Math  {
        return Math(display: display, content: Math.Content(inner: .operation(.other(.isIn), lhs: self.content, rhs: math.content), shell: .none))
    }
    
    public func isSubset(of math: Math) -> Math  {
        return Math(display: display, content: Math.Content(inner: .operation(.other(.isSubset), lhs: self.content, rhs: math.content), shell: .none))
    }
    
    public func isSubsetOrEqual(to math: Math) -> Math  {
        return Math(display: display, content: Math.Content(inner: .operation(.other(.isSubsetOrEqual), lhs: self.content, rhs: math.content), shell: .none))
    }
}

public extension Math {
    public var abs: Math {
        return Math.abs(self)
    }
}

public extension Math {
    public func det(for subs: Math ...) -> Math {
        return Math.det(self).sub(Math(list: subs))
    }
}

public extension String {
    public func sub(_ rhs: Math ...) -> Math {
        return Math(stringLiteral: self).sub(Math(list: rhs))
    }
    
    public func sub(_ from: Math, to: Math) -> Math {
        return Math(stringLiteral: self).sub(from, to: to)
    }
}

public extension Array where Element == Math {
    public func isIn(_ set: Math) -> Math {
        return Math(array: self).isIn(set)
    }
}

public extension Math {
    public func function(from: Math, to: Math) -> Math {
        return Math(display: display, content: .operation(.other(.colon), lhs: content, rhs: .operation(.other(.rightArrow), lhs: from.content, rhs: to.content)))
    }
}

public extension Math {
    public var prime: Math {
        return Math(display: display, content: .postfix(.prime, inner: self.content))
    }
}


