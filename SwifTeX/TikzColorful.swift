//
//  TikzColorful.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-22.
//  Copyright © 2018 Wircho. All rights reserved.
//

import AppKit

internal protocol TikzColorful {
    var colorNamer: ColorNamer { get }
    var fillColor: NSColor? { get }
    var lineColor: NSColor? { get }
}

internal extension TikzColorful {
    internal var colorHeaders: [String] {
        return [fillColor.map{ "\\definecolor{\(self.colorNamer.fill)}{rgb}{\($0.tupleString)}" }, lineColor.map{ "\\definecolor{\(colorNamer.line)}{rgb}{\($0.tupleString)}" }].compactMap{ $0 }
    }
    
    internal var colorDescriptions: [String] {
        return [fillColor.map { _ in "fill = \(colorNamer.fill)" }, lineColor.map { _ in "draw = \(colorNamer.line)" }].compactMap{ $0 }
    }
}
