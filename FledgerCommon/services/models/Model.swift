//
//  Model.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import SQLite
#if os(iOS)
import Parse
#elseif os(OSX)
import ParseOSX
#endif


public protocol Model: Equatable, PFObjectConvertible {
    
    var id: Int64? { get }
    var modelType: ModelType { get }
    var pf: PFObject? { get }
    
    func toSetters() -> [Setter]
    
    func parse() -> ParseModel?
    
}
