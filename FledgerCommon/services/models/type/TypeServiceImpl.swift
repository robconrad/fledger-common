//
//  TypeService.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/12/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite


class TypeServiceImpl: TypeService, HasShieldedPersistenceEngine {
    
    let transferId: Int64 = 28
    
    let engine = ShieldedPersistenceEngine(engine: MemoryPersistenceEngine<Type>(
        modelType: ModelType.Typ,
        fromPFObject: { pf in Type(pf: pf) },
        fromRow: { row in Type(row: row) },
        table: DatabaseSvc().types,
        defaultOrder: { q in q.order(Fields.name) }
    ))
    
    func transferType() -> Type {
        return withId(transferId)!
    }
    
    func withName(name: String) -> Type? {
        return all().filter { $0.name == name }.first
    }
    
}