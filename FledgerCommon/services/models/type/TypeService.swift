//
//  LocationService.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/3/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Foundation
#if os(iOS)
import Parse
#elseif os(OSX)
import ParseOSX
#endif


public protocol TypeService: ModelService {
    
    /****************************************************************************
    BEGIN common model-specific functions that cannot be defined in ModelService
    ****************************************************************************/
    func fromPFObject(pf: PFObject) -> Type
    func withId(id: Int64) -> Type?
    func all() -> [Type]
    func select(filters: Filters?) -> [Type]
    func insert(e: Type) -> Int64?
    func update(e: Type) -> Bool
    func delete(e: Type) -> Bool
    /****************************************************************************
    END common model-specific functions that cannot be defined in ModelService
    ****************************************************************************/
    
    var transferId: Int64 { get }
    
    func transferType() -> Type
    
    func withName(name: String) -> Type?
    
}