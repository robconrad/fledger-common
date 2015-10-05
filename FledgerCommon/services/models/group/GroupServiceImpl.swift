//
//  TypeService.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/12/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite


class GroupServiceImpl: GroupService, HasShieldedPersistenceEngine {
    
    let engine = ShieldedPersistenceEngine(engine: MemoryPersistenceEngine<Group>(
        modelType: ModelType.Group,
        fromPFObject: { pf in Group(pf: pf) },
        fromRow: { row in Group(row: row) },
        table: DatabaseSvc().groups,
        defaultOrder: { q in q.order(Fields.name) }
    ))
        
    func withTypeId(id: Int64) -> Group? {
        if let type = TypeSvc().withId(id) {
            return engine.withId(type.groupId)
        }
        return nil
    }
    
    func withName(name: String) -> Group? {
        return engine.all().filter { $0.name == name }.first
    }
    
}