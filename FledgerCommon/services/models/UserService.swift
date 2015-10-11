//
//  ParseService.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/10/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Foundation


public protocol UserService: Service {
    
    func getType() -> UserType
    
    func isLoggedIn() -> Bool
    func login(email: String, _ password: String, _ onComplete: Bool -> Void)
    func logout()
    func signup(email: String, _ password: String, _ onComplete: Bool -> Void)
    
    func syncAllToRemote()
    func syncAllToRemoteInBackground()
    
    func syncAllFromRemote()
    func syncAllFromRemoteInBackground()
    
    func notifySyncListeners(syncType: UserDataSyncType)
    func registerSyncListener(listener: UserDataSyncListener)
    func ungregisterSyncListener(listener: UserDataSyncListener)
    
}

public func ==(lhs: UserDataSyncListener, rhs: UserDataSyncListener) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

public class UserDataSyncListener: Hashable {
    
    private let notifyCallback: UserDataSyncType -> ()
    
    public required init(notify: UserDataSyncType -> ()) {
        self.notifyCallback = notify
    }
    
    public let hashValue = Int(arc4random()) // Fuck it. I don't care.
    
    public func notify(syncType: UserDataSyncType) {
        notifyCallback(syncType)
    }
    
}

public enum UserDataSyncType {
    case To
    case From
}