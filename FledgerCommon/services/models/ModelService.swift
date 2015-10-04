//
//  Manager.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//


public protocol ModelService: Service {
    
    typealias M: Model
    
    func modelType() -> ModelType
    
    func withId(id: Int64) -> M?
    
    func all() -> [M]
    func select(filters: Filters?) -> [M]
    
    func count(filters: Filters?) -> Int
    
    func insert(e: M) -> Int64?
    
    func update(e: M) -> Bool
    
    func delete(e: M) -> Bool
    func delete(id: Int64) -> Bool
    
    func invalidate()
    
    func syncToRemote()
    func syncFromRemote()
    
}