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


public class LocationService: ModelService {
    
    public typealias M = Location
    
    public func itemCount(id: Int64) -> Int {
        fatalError()
    }
    
    public func nearest(coordinate: CLLocationCoordinate2D, sortBy: LocationSortBy) -> [Location] {
        fatalError()
    }
    
    public func cleanup() {
        fatalError()
    }
    
}

class PFLocationService: LocationService, PFModelService {
    
    let _svc = StandardModelServiceImpl<Location>()
    
    var svc: StandardModelServiceImpl<Location> {
        get {
            return _svc
        }
    }
    
}

public enum LocationSortBy: String {
    case Name = "Name"
    case Distance = "Distance"
}