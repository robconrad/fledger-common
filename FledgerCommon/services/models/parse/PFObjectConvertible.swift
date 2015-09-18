//
//  CanCreatePFObject.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/14/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Foundation
#if os(iOS)
import Parse
#elseif os(OSX)
import ParseOSX
#endif


protocol PFObjectConvertible {
    
    func toPFObject() -> PFObject?
    
}