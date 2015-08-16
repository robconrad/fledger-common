//
//  ParseFilters.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/14/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Foundation
import SQLite

public class ParseFilters: Filters {

    public var modelType: ModelType?
    public var synced: Bool?
    public var deleted: Bool?
    
    public override func toQuery(var query: Query, limit: Bool = true, table: Query? = nil) -> Query {
        
        query = super.toQuery(query, limit: limit)
        
        if let mt = modelType {
            query = query.filter(Fields.model == mt.rawValue)
        }
        if let s = synced {
            query = query.filter(Fields.synced == s)
        }
        if let d = deleted {
            query = query.filter(Fields.deleted == d)
        }
        
        return query
    }
    
}