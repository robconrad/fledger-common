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


protocol HasShieldedPersistenceEngine {
    
    typealias E: PersistenceEngine
    
    var engine: ShieldedPersistenceEngine<E.M, E> {
        get
    }
    
}

extension HasShieldedPersistenceEngine  {
    
    func modelType() -> ModelType {
        return engine.modelType()
    }
    
    func fromPFObject(pf: PFObject) -> E.M {
        return engine.fromPFObject(pf)
    }
    
    func withId(id: Int64) -> E.M? {
        return engine.withId(id)
    }
    
    func all() -> [E.M] {
        return engine.all()
    }
    
    func select(filters: Filters?) -> [E.M] {
        return engine.select(filters)
    }
    
    func count(filters: Filters?) -> Int {
        return engine.count(filters)
    }
    
    func insert(e: E.M) -> Int64? {
        return engine.insert(e)
    }
    
    func update(e: E.M) -> Bool {
        return engine.update(e)
    }
    
    func delete(e: E.M) -> Bool {
        return engine.delete(e)
    }
    
    func delete(id: Int64) -> Bool {
        return engine.delete(id)
    }
    
    func invalidate() {
        engine.invalidate()
    }
    
    func syncToRemote() {
        engine.syncToRemote()
    }
    
    func syncFromRemote() {
        engine.syncFromRemote()
    }
    
}
