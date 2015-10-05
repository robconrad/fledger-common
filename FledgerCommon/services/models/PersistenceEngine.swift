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


protocol PersistenceEngine: ModelService {
    
    typealias M: PFModel, SqlModel
    
    /****************************************************************************
    BEGIN common model-specific functions that cannot be defined in ModelService
    ****************************************************************************/
    func fromPFObject(pf: PFObject) -> M
    func withId(id: Int64) -> M?
    func all() -> [M]
    func select(filters: Filters?) -> [M]
    func insert(e: M) -> Int64?
    func update(e: M) -> Bool
    func delete(e: M) -> Bool
    /****************************************************************************
    END common model-specific functions that cannot be defined in ModelService
    ****************************************************************************/
    
}
