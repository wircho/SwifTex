//
//  Inserting.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-04.
//  Copyright © 2018 Wircho. All rights reserved.
//

infix operator <-: AssignmentPrecedence
infix operator <!-: AssignmentPrecedence

public extension Document {
    
    public static func <!-(document: Document, text: String) {
        document.innerContent += " " + text
    }
    
    public static func <-(document: Document, text: String) {
        document.innerContent += " " + escape(text)
    }
    
}
