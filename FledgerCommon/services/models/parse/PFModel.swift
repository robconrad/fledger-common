//
//  PFModel.swift
//  FledgerCommon
//
//  Created by Robert Conrad on 9/18/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Foundation
#if os(iOS)
import Parse
#elseif os(OSX)
import ParseOSX
#endif

// private extension of Model that provides PF conveniences
protocol PFModel: Model, PFObjectConvertible {
    
    var pf: PFObject? { get }
    
    func parse() -> ParseModel?
    
}