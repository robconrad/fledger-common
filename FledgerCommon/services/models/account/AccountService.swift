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


public class AccountService: ModelService {
    
    public typealias M = Account
    
    public func withName(name: String) -> Account? {
        fatalError()
    }
    
}

class PFAccountService: AccountService, PFModelService {
    
    let _svc = MemoryModelServiceImpl<Account>()
    
    var svc: StandardModelServiceImpl<Account> {
        get {
            return _svc
        }
    }
    
}