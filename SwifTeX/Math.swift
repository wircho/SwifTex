//
//  Math.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-07.
//  Copyright © 2018 Wircho. All rights reserved.
//

public struct Math {
    internal enum Precedence: Double, Comparable {
        case list = 500
        case assignment = 1000
        case addition = 2000
        case multiplication = 3000
        case raising = 4000
        case subscripting = 5000
        case group = 6000
        
        var associative: Bool {
            switch self {
            case .assignment, .addition, .multiplication, .list: return true
            case .raising, .subscripting, .group: return false
            }
        }
        
        static func <(lhs: Math.Precedence, rhs: Math.Precedence) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
    }
    
    internal enum Shell {
        case letter
        case number
        case bracket
        case nothing
        case fraction
        case exponent
        case symbol
    }
    
    internal let display: Bool
    internal let displayStyle: Bool
    internal let precedence: Precedence
    internal let singleHeight: Bool
    internal let shell: (left: Shell, right: Shell)
    internal let code: String
    
    internal init(display: Bool = false, displayStyle: Bool = false, precedence: Precedence, singleHeight: Bool, shell: (left: Shell, right: Shell), code: String) {
        self.display = display
        self.displayStyle = displayStyle
        self.precedence = precedence
        self.singleHeight = singleHeight
        self.shell = shell
        self.code = code
    }
}
