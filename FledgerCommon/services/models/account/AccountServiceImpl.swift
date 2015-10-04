//
//  File.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/12/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite


class AccountServiceImpl: PFAccountService {
    
    func modelType() -> ModelType {
        return ModelType.Account
    }
    
    internal func table() -> SchemaType {
        return DatabaseSvc().accounts
    }
    
    func defaultOrder(query: SchemaType) -> SchemaType {
        return query.order(Fields.priority, Fields.name)
    }
    
    func select(filters: Filters?) -> [Account] {
        var elements: [Account] = []
        
        for row in DatabaseSvc().db.prepare(svc.baseQuery(filters)) {
            elements.append(Account(row: row))
        }
        
        return elements
    }
    
    override func withName(name: String) -> Account? {
        return all().filter { $0.name == name }.first
    }
    
}