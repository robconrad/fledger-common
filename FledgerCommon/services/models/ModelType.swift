//
//  Models.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/13/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation


public enum ModelType: String, Printable {
    
    case Group = "group"
    case Typ = "type"
    case Account = "account"
    case Location = "location"
    case Item = "item"
    
    public var description: String {
        return rawValue
    }
    
}