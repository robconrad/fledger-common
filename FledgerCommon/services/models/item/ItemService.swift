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


public protocol ItemService: ModelService {
    
    /****************************************************************************
    BEGIN common model-specific functions that cannot be defined in ModelService
    ****************************************************************************/
    func fromPFObject(pf: PFObject) -> Item
    func withId(id: Int64) -> Item?
    func all() -> [Item]
    func select(filters: Filters?) -> [Item]
    func insert(e: Item) -> Int64?
    func update(e: Item) -> Bool
    func delete(e: Item) -> Bool
    /****************************************************************************
    END common model-specific functions that cannot be defined in ModelService
    ****************************************************************************/
    
    func getTransferPair(first: Item) -> Item?
    
    func getSum(item: Item, filters: Filters) -> Double
    
    func getFiltersFromDefaults() -> ItemFilters
    
    func defaultCount() -> Int
    
}