//
//  PersistenceEngine.swift
//  FledgerCommon
//
//  Created by Robert Conrad on 10/4/15.
//  Copyright © 2015 Robert Conrad. All rights reserved.
//

#if os(iOS)
import Parse
#elseif os(OSX)
import ParseOSX
#endif


struct ShieldedPersistenceEngine<M, E where M: PFModel, M: SqlModel, E: PersistenceEngine, E.M == M>: PersistenceEngine {
    
    let engine: E
    
    func modelType() -> ModelType {
        return engine.modelType()
    }
    
    func fromPFObject(pf: PFObject) -> M {
        return engine.fromPFObject(pf)
    }
    
    func withId(id: Int64) -> M? {
        return engine.withId(id)
    }
    
    func all() -> [M] {
        return engine.all()
    }
    
    func select(filters: Filters?) -> [M] {
        return engine.select(filters)
    }
    
    func count(filters: Filters?) -> Int {
        return engine.count(filters)
    }
    
    func insert(e: M) -> Int64? {
        return engine.insert(e)
    }
    
    func update(e: M) -> Bool {
        return engine.update(e)
    }
    
    func delete(e: M) -> Bool {
        return engine.delete(e)
    }
    
    func delete(id: Int64) -> Bool {
        return engine.delete(id)
    }
    
    func invalidate() {
        return engine.invalidate()
    }
    
    func syncToRemote() {
        return engine.syncToRemote()
    }
    
    func syncFromRemote() {
        return engine.syncFromRemote()
    }
    
}
