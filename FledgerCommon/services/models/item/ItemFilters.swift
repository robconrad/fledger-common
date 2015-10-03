//
//  ItemFilters.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite


public func ==(a: ItemFilters, b: ItemFilters) -> Bool {
    let x = a.accountId == b.accountId
        && a.startDate == b.startDate
        && a.endDate == b.endDate
    let y = a.typeId == b.typeId
        && a.groupId == b.groupId
        && a.count == b.count
        && a.offset == b.offset
    return x && y
}

public class ItemFilters: Filters {
    
    public var accountId: Int64?
    public var startDate: NSDate?
    public var endDate: NSDate?
    public var typeId: Int64?
    public var groupId: Int64?
    
    override func toQuery(var query: SchemaType, limit: Bool = true, table: SchemaType? = nil) -> SchemaType {
        
        query = super.toQuery(query, limit: limit)
        
        if let id = accountId {
            query = query.filter(Fields.accountId == id)
        }
        if let id = typeId {
            query = query.filter(Fields.typeId == id)
        }
        if let id = groupId {
            query = query.filter(Fields.groupId == id)
        }
        if let date = startDate {
            query = query.filter(Fields.date >= date)
        }
        if let date = endDate {
            query = query.filter(Fields.date <= date)
        }
        
        return query
    }
    
    public func strings() -> [String] {
        var s: [String] = []
        
        if let id = accountId {
            s.append("Filtered by Account: " + (AccountSvc().withId(id)?.name ?? "?"))
        }
        if let id = typeId {
            s.append("Filtered by Type: " + (TypeSvc().withId(id)?.name ?? "?"))
        }
        if let id = groupId {
            s.append("Filtered by Group: " + (GroupSvc().withId(id)?.name ?? "?"))
        }
        if let date = startDate {
            s.append("Filtered by Start Date: " + date.uiValue)
        }
        if let date = endDate {
            s.append("Filtered by End Date: " + date.uiValue)
        }
        
        return s
    }
    
    public func countFilters() -> Int {
        return strings().count
    }
    
    public func save() {
        if let id = accountId {
            NSUserDefaults.standardUserDefaults().setObject(NSNumber(longLong: id), forKey: "filters.accountId")
        }
        else {
            NSUserDefaults.standardUserDefaults().removeObjectForKey("filters.accountId")
        }
        if let date = startDate {
            NSUserDefaults.standardUserDefaults().setObject(date, forKey: "filters.startDate")
        }
        else {
            NSUserDefaults.standardUserDefaults().removeObjectForKey("filters.startDate")
        }
        if let date = endDate {
            NSUserDefaults.standardUserDefaults().setObject(date, forKey: "filters.endDate")
        }
        else {
            NSUserDefaults.standardUserDefaults().removeObjectForKey("filters.endDate")
        }
        if let id = typeId {
            NSUserDefaults.standardUserDefaults().setObject(NSNumber(longLong: id), forKey: "filters.typeId")
        }
        else {
            NSUserDefaults.standardUserDefaults().removeObjectForKey("filters.typeId")
        }
        if let id = groupId {
            NSUserDefaults.standardUserDefaults().setObject(NSNumber(longLong: id), forKey: "filters.groupId")
        }
        else {
            NSUserDefaults.standardUserDefaults().removeObjectForKey("filters.groupId")
        }
    }
    
    public func addAggregate(agg: Aggregate) {
        if let model = agg.model {
            switch model {
            case .Account: accountId = agg.id
            case .Group: groupId = agg.id
            case .Typ: typeId = agg.id
            case .Location: break
            case .Item: break
            }
        }
    }
    
    public func clear() {
        accountId = nil
        startDate = nil
        endDate = nil
        typeId = nil
        groupId = nil
    }
    
}
