//
//  Item.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import CoreLocation
import Foundation
import SQLite
#if os(iOS)
import Parse
#elseif os(OSX)
import ParseOSX
#endif


public func ==(a: Location, b: Location) -> Bool {
    return a.id == b.id
        && a.name == b.name
        && a.coordinate.latitude == b.coordinate.latitude
        && a.coordinate.longitude == b.coordinate.longitude
        && a.address == b.address
        && a.distance == b.distance
}

public class Location: Model, Printable {
    
    public let modelType = ModelType.Location
    
    public let id: Int64?
    
    public let name: String?
    public let coordinate: CLLocationCoordinate2D
    public let address: String
    public let distance: Double?
    
    public let pf: PFObject?
    
    public var description: String {
        return "Location(id: \(id), name: \(name), coordinate: \(coordinate), address: \(address), distance: \(distance), pf: \(pf))"
    }
    
    public required init(id: Int64?, name: String?, coordinate: CLLocationCoordinate2D, address: String, distance: Double? = nil, pf: PFObject? = nil) {
        self.id = id
        self.name = name
        self.coordinate = coordinate
        self.address = address
        self.distance = distance
        self.pf = pf
    }
    
    public convenience init(id: Int64?, name: String?, latitude: Double, longitude: Double, address: String, distance: Double? = nil, pf: PFObject? = nil) {
        self.init(
            id: id,
            name: name,
            coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            address: address,
            distance: distance,
            pf: pf)
    }
    
    public convenience init(row: Row) {
        self.init(
            id: row.get(Fields.id),
            name: row.get(Fields.nameOpt),
            latitude: row.get(Fields.latitude),
            longitude: row.get(Fields.longitude),
            address: row.get(Fields.address))
    }
    
    public convenience init(pf: PFObject) {
        self.init(
            id: pf.objectId.flatMap { ParseSvc().withParseId($0, ModelType.Location) }?.modelId,
            name: pf["name"] as? String,
            latitude: pf["latitude"] as! Double,
            longitude: pf["longitude"] as! Double,
            address: pf["address"] as! String,
            pf: pf)
    }
    
    public func toSetters() -> [Setter] {
        return [
            Fields.nameOpt <- name,
            Fields.latitude <- coordinate.latitude,
            Fields.longitude <- coordinate.longitude,
            Fields.address <- address
        ]
    }
    
    public func toPFObject() -> PFObject? {
        if id != nil {
            let npf = PFObject(withoutDataWithClassName: modelType.rawValue, objectId: pf?.objectId ?? parse()?.parseId)
            npf["name"] = name ?? NSNull()
            npf["latitude"] = coordinate.latitude.datatypeValue
            npf["longitude"] = coordinate.longitude.datatypeValue
            npf["address"] = address
            return npf
        }
        return nil
    }
    
    public func parse() -> ParseModel? {
        return id.flatMap { ParseSvc().withModelId($0, modelType) }
    }
    
    public func copy(name: String? = nil, coordinate: CLLocationCoordinate2D? = nil, address: String? = nil) -> Location {
        return Location(
            id: id,
            name: name ?? self.name,
            coordinate: coordinate ?? self.coordinate,
            address: address ?? self.address)
    }
    
    public func withId(id: Int64?) -> Location {
        return Location(
            id: id,
            name: name,
            coordinate: coordinate,
            address: address,
            distance: distance)
    }
    
    public func title() -> String {
        return name ?? address
    }
    
}