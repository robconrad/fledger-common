//
//  LocationService.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/3/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Foundation
#if os(iOS)
import Parse
#elseif os(OSX)
import ParseOSX
#endif


public class TypeService: ModelService {
    
    public typealias M = Type
    
    public var transferId: Int64 {
        get { return 0 }
    }
    
    public func transferType() -> Type {
        fatalError()
    }
    
    public func withName(name: String) -> Type? {
        fatalError()
    }
    
}

class PFTypeService: TypeService, PFModelService {
    
    let _svc = MemoryModelServiceImpl<Type>()
    
    var svc: StandardModelServiceImpl<Type> {
        get {
            return _svc
        }
    }
    
}