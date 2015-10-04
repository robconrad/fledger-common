//
//  TypeService.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/12/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite
import MapKit
#if os(iOS)
import Parse
#elseif os(OSX)
import ParseOSX
#endif


class LocationServiceImpl: PFLocationService {
    
    func modelType() -> ModelType {
        return ModelType.Location
    }
    
    internal func table() -> SchemaType {
        return DatabaseSvc().locations
    }
    
    func defaultOrder(query: SchemaType) -> SchemaType {
        return query.order(Fields.name)
    }
    
    func select(filters: Filters?) -> [Location] {
        var elements: [Location] = []
        
        for row in DatabaseSvc().db.prepare(svc.baseQuery(filters)) {
            elements.append(Location(row: row))
        }
        
        return elements
    }
    
    override func itemCount(id: Int64) -> Int {
        return DatabaseSvc().db.scalar(DatabaseSvc().items.filter(Fields.locationId == id).count)
    }
    
    override func nearest(coordinate: CLLocationCoordinate2D, sortBy: LocationSortBy) -> [Location] {
        
        let orderBy: String
        switch sortBy {
        case .Name: orderBy = "CASE WHEN name IS NULL THEN address ELSE name END"
        case .Distance: orderBy = "computedDistance"
        }
        
        var elements: [Location] = []
        let stmt = DatabaseSvc().db.prepare("SELECT id, name, latitude, longitude, address, distance(latitude, longitude, ?, ?) AS computedDistance FROM locations ORDER BY \(orderBy)")
        
        do {
            for row in try stmt.run(coordinate.latitude, coordinate.longitude) {
                elements.append(Location(
                    id: (row[0] as! Int64),
                    name: row[1] as? String,
                    latitude: row[2] as! Double,
                    longitude: row[3] as! Double,
                    address: row[4] as! String,
                    distance: row[5] as? Double)
                )
            }
        } catch {
            
        }
        
        return elements
    }

    override func cleanup() {
        // TODO delete locations that have 0 items attached
    }
    
}