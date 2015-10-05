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


public protocol LocationService: ModelService {
    
    /****************************************************************************
    BEGIN common model-specific functions that cannot be defined in ModelService
    ****************************************************************************/
    func fromPFObject(pf: PFObject) -> Location
    func withId(id: Int64) -> Location?
    func all() -> [Location]
    func select(filters: Filters?) -> [Location]
    func insert(e: Location) -> Int64?
    func update(e: Location) -> Bool
    func delete(e: Location) -> Bool
    /****************************************************************************
    END common model-specific functions that cannot be defined in ModelService
    ****************************************************************************/
    
    func itemCount(id: Int64) -> Int
    
    func nearest(coordinate: CLLocationCoordinate2D, sortBy: LocationSortBy) -> [Location]
    
    func cleanup()
    
}

public enum LocationSortBy: String {
    case Name = "Name"
    case Distance = "Distance"
}