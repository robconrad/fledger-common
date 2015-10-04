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


public class ItemService: ModelService {
    
    public typealias M = Item
    
    public func getTransferPair(first: Item) -> Item? {
        fatalError()
    }
    
    public func getSum(item: Item, filters: Filters) -> Double {
        fatalError()
    }
    
    public func getFiltersFromDefaults() -> ItemFilters {
        fatalError()
    }
    
    public func defaultCount() -> Int {
        fatalError()
    }
    
}

class PFItemService: ItemService, PFModelService {
    
    let _svc = StandardModelServiceImpl<Item>()
    
    var svc: StandardModelServiceImpl<Item> {
        get {
            return _svc
        }
    }
    
}