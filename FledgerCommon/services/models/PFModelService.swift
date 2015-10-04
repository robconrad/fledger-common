//
//  PFModelService.swift
//  FledgerCommon
//
//  Created by Robert Conrad on 10/3/15.
//  Copyright © 2015 Robert Conrad. All rights reserved.
//

#if os(iOS)
import Parse
#elseif os(OSX)
import ParseOSX
#endif

protocol PFModelService: ModelService {
    
    typealias M: PFModel, SqlModel
    
    var svc: StandardModelServiceImpl<M> {
        get
    }
    
    func fromPFObject(pf: PFObject) -> M
    
}

extension PFModelService {
    
    func fromPFObject(pf: PFObject) -> M {
        return svc.fromPFObject(pf)
    }
    
    func modelType() -> ModelType {
        return svc.modelType()
    }
    
    func withId(id: Int64) -> M? {
        return svc.withId(id)
    }
    
    func all() -> [M] {
        return svc.all()
    }
    func select(filters: Filters?) -> [M] {
        return svc.select(filters)
    }
    
    func count(filters: Filters?) -> Int {
        return svc.count(filters)
    }
    
    func insert(e: M) -> Int64? {
        return svc.insert(e)
    }
    
    func update(e: M) -> Bool {
        return svc.update(e)
    }
    
    func delete(e: M) -> Bool {
        return svc.delete(e)
    }
    func delete(id: Int64) -> Bool {
        return svc.delete(id)
    }
    
    func invalidate() {
        svc.invalidate()
    }
    
    func syncToRemote() {
        svc.syncFromRemote()
    }
    func syncFromRemote() {
        svc.syncFromRemote()
    }
    
}
