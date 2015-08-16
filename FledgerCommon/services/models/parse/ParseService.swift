//
//  ParseService.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/10/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Foundation
import Parse

typealias ParseId = String

public protocol ParseService: Service {
    
    func select(filters: ParseFilters?) -> [ParseModel]
    
    func withModelId(id: Int64, _ modelType: ModelType) -> ParseModel?
    
    func withParseId(id: String, _ modelType: ModelType) -> ParseModel?
    
    func markSynced(id: Int64, _ modelType: ModelType, _ pf: PFObject) -> Bool
    
    func save(convertible: PFObjectConvertible) -> PFObject?
    
    func remote(modelType: ModelType, updatedOnly: Bool) -> [PFObject]?
    
    func syncAllToRemote()
    func syncAllToRemoteInBackground()
    
    func syncAllFromRemote()
    func syncAllFromRemoteInBackground()
    
    func notifySyncListeners(syncType: ParseSyncType)
    func registerSyncListener(listener: ParseSyncListener)
    func ungregisterSyncListener(listener: ParseSyncListener)
    
    func isLoggedIn() -> Bool
    func login(email: String, _ password: String) -> Bool
    func logout()
    func signup(email: String, _ password: String) -> Bool
    
}

public func ==(lhs: ParseSyncListener, rhs: ParseSyncListener) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

public class ParseSyncListener: Hashable {
    
    private let notifyCallback: ParseSyncType -> ()
    
    public required init(notify: ParseSyncType -> ()) {
        self.notifyCallback = notify
    }
    
    public let hashValue = Int(arc4random()) // Fuck it. I don't care.
    
    public func notify(syncType: ParseSyncType) {
        notifyCallback(syncType)
    }
    
}

public enum ParseSyncType {
    case To
    case From
}