//
//  TypeService.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/12/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite


class TypeServiceImpl: PFTypeService {
    
    override var transferId: Int64 {
        get { return 28 }
    }
    
    func modelType() -> ModelType {
        return ModelType.Typ
    }
    
    internal func table() -> SchemaType {
        return DatabaseSvc().types
    }
    
    func defaultOrder(query: SchemaType) -> SchemaType {
        return query.order(Fields.name)
    }
    
    func select(filters: Filters?) -> [Type] {
        var elements: [Type] = []
        
        for row in DatabaseSvc().db.prepare(svc.baseQuery(filters)) {
            elements.append(Type(row: row))
        }
        
        return elements
    }
    
    override func transferType() -> Type {
        return withId(transferId)!
    }
    
    override func withName(name: String) -> Type? {
        return all().filter { $0.name == name }.first
    }
    
}