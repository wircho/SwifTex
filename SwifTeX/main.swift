//
//  main.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-03.
//  Copyright © 2018 Wircho. All rights reserved.
//

import AppKit

func compile() throws {
    _ = try DeterminantIdentityPaper.main().save().compile().open()
}

try! compile()
