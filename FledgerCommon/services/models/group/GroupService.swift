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


public protocol GroupService: ModelService {
    
    /****************************************************************************
    BEGIN common model-specific functions that cannot be defined in ModelService
    ****************************************************************************/
    func fromPFObject(pf: PFObject) -> Group
    func withId(id: Int64) -> Group?
    func all() -> [Group]
    func select(filters: Filters?) -> [Group]
    func insert(e: Group) -> Int64?
    func update(e: Group) -> Bool
    func delete(e: Group) -> Bool
    /****************************************************************************
    END common model-specific functions that cannot be defined in ModelService
    ****************************************************************************/

    func withTypeId(id: Int64) -> Group?
    func withName(name: String) -> Group?
    
}