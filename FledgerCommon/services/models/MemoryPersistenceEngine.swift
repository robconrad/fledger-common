//
//  StandardPersistenceEngine.swift
//  FledgerCommon
//
//  Created by Robert Conrad on 10/4/15.
//  Copyright © 2015 Robert Conrad. All rights reserved.
//

import SQLite
#if os(iOS)
import Parse
#elseif os(OSX)
import ParseOSX
#endif


class MemoryPersistenceEngine<M where M: PFModel, M: SqlModel>: StandardPersistenceEngine<M> {
    
    // return all managed models of the type
    internal var _allArray: [M]?
    internal var _allDict: [Int64: M]?
    
    required init(
        modelType: ModelType,
        fromPFObject: PFObject -> M,
        fromRow: Row -> M,
        table: SchemaType,
        defaultOrder: (SchemaType) -> SchemaType = { q in q.order(Fields.id.desc) }
    ) {
        super.init(
            modelType: modelType,
            fromPFObject: fromPFObject,
            fromRow: fromRow,
            table: table,
            defaultOrder: defaultOrder)
    }
    
    override func withId(id: Int64) -> M? {
        if let a = _allDict {
            return a[id]
        }
        else {
            all()
            return withId(id)
        }
    }
    
    override func all() -> [M] {
        if _allArray == nil {
            _allArray = super.all()
            _allDict = Dictionary<Int64, M>()
            for e in _allArray! {
                _allDict![e.id!] = e
            }
        }
        return _allArray!
    }
    
    override func count(filters: Filters?) -> Int {
        return _allArray!.count
    }
    
    override func insert(e: M) -> Int64? {
        let id = super.insert(e)
        
        if id != nil {
            invalidate()
        }
        
        return id
    }
    
    override func update(e: M) -> Bool {
        let result = super.update(e)
        
        if result {
            invalidate()
        }
        
        return result
    }
    
    override func delete(id: Int64) -> Bool {
        let result = super.delete(id)
        
        if result {
            invalidate()
        }
        
        return result
    }
    
    override func invalidate() {
        _allArray = nil
        _allDict = nil
    }
    
}

