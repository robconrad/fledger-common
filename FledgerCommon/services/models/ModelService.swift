//
//  Manager.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//


public protocol ModelService: Service {
    
    func modelType() -> ModelType
    
    func count(filters: Filters?) -> Int
    
    func delete(id: Int64) -> Bool
    
    func invalidate()

    func syncToRemote()
    func syncFromRemote()
    
}
