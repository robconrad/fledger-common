//
//  File.swift
//  FledgerCommon
//
//  Created by Robert Conrad on 9/18/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import SQLite


protocol SqlModel: Model {
    
    func toSetters() -> [Setter]
    
}