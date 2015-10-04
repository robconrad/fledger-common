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


public class GroupService: PFModelService {
    
    public typealias M = Group
    
    let _svc = MemoryModelServiceImpl<Group>()
    
    var svc: StandardModelServiceImpl<Group> {
        get {
            return _svc
        }
    }

    public func withTypeId(id: Int64) -> Group? {
        fatalError()
    }
    
    public func withName(name: String) -> Group? {
        fatalError()
    }
    
}
