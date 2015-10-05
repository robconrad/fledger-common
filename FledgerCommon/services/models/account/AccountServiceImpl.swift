//
//  File.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/12/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite
#if os(iOS)
import Parse
#elseif os(OSX)
import ParseOSX
#endif


class AccountServiceImpl: AccountService, HasShieldedPersistenceEngine {
    
    let engine = ShieldedPersistenceEngine(engine: MemoryPersistenceEngine<Account>(
        modelType: ModelType.Account,
        fromPFObject: { pf in Account(pf: pf) },
        fromRow: { row in Account(row: row) },
        table: DatabaseSvc().accounts,
        defaultOrder: { q in q.order(Fields.priority, Fields.name) }
    ))
    
    func withName(name: String) -> Account? {
        return engine.all().filter { $0.name == name }.first
    }
    
}
