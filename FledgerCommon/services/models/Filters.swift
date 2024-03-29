//
//  Filters.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/12/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite

public class Filters {
    
    public var ids: Set<Int64>?
    
    public var offset: Int?
    public var count: Int?
    
    public required init() {
        
    }
    
    func toQuery(var query: SchemaType, limit: Bool = true, table: SchemaType? = nil) -> SchemaType {
        
        if let myIds = ids {
            var field = Fields.id
            if let t = table {
                field = t[field]
            }
            query = query.filter(myIds.contains(field))
        }
        
        if limit && (offset != nil || count != nil) {
            let myOffset = offset ?? 0
            let myCount = count ?? Int.max
            query = query.limit(myCount, offset: myOffset)
        }
        
        return query
    }
    
}