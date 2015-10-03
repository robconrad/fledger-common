//
//  ParseService.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/10/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Foundation
#if os(iOS)
import Parse
#elseif os(OSX)
import ParseOSX
#endif

typealias ParseId = String

protocol ParseService: Service {
    
    func select(filters: ParseFilters?) -> [ParseModel]
    
    func withModelId(id: Int64, _ modelType: ModelType) -> ParseModel?
    
    func withParseId(id: String, _ modelType: ModelType) -> ParseModel?
    
    func markSynced(id: Int64, _ modelType: ModelType, _ pf: PFObject) -> Bool
    
    func save(convertible: PFObjectConvertible) -> PFObject?
    
    func remote(modelType: ModelType, updatedOnly: Bool) -> [PFObject]?
    
    func isLoggedIn() -> Bool
    func login(email: String, _ password: String) -> Bool
    func logout()
    func signup(email: String, _ password: String) -> Bool
    
}