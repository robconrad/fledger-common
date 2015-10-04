//
//  TypeService.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/12/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite


class GroupServiceImpl: GroupService {
    
    func modelType() -> ModelType {
        return ModelType.Group
    }
    
    internal func table() -> SchemaType {
        return DatabaseSvc().groups
    }
    
    func defaultOrder(query: SchemaType) -> SchemaType {
        return query.order(Fields.name)
    }
    
    func select(filters: Filters?) -> [Group] {
        var elements: [Group] = []
        
        for row in DatabaseSvc().db.prepare(svc.baseQuery(filters)) {
            elements.append(Group(row: row))
        }
        
        return elements
    }
    
    override func withTypeId(id: Int64) -> Group? {
        if let type = TypeSvc().withId(id) {
            return withId(type.groupId)
        }
        return nil
    }
    
    override func withName(name: String) -> Group? {
        return all().filter { $0.name == name }.first
    }
    
}