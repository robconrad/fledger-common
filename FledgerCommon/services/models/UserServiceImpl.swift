//
//  UserServiceImpl.swift
//  FledgerCommon
//
//  Created by Robert Conrad on 9/18/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Foundation


class UserServiceImpl: UserService {
    
    private var syncListeners = Set<UserDataSyncListener>()
    
    private let syncToRemoteQueue: NSOperationQueue = {
        var q = NSOperationQueue()
        q.name = "UserServiceImpl SyncTo Background Queue"
        q.maxConcurrentOperationCount = 1
        return q
        }()
    
    private let syncFromRemoteQueue: NSOperationQueue = {
        var q = NSOperationQueue()
        q.name = "UserServiceImpl SyncFrom Background Queue"
        q.maxConcurrentOperationCount = 1
        return q
        }()
    
    func getType() -> UserType {
        return .Remote
    }
    
    func isLoggedIn() -> Bool {
        return ParseSvc().isLoggedIn()
    }
    
    func login(email: String, _ password: String) -> Bool {
        return ParseSvc().login(email, password)
    }
    
    func logout() {
        return ParseSvc().logout()
    }
    
    func signup(email: String, _ password: String) -> Bool {
        return ParseSvc().signup(email, password)
    }
    
    func syncAllToRemote() {
        // order matters because of FK resolution
        LocationSvc().syncToRemote()
        GroupSvc().syncToRemote()
        TypeSvc().syncToRemote()
        AccountSvc().syncToRemote()
        ItemSvc().syncToRemote()
    }
    
    func syncAllToRemoteInBackground() {
        syncToRemoteQueue.cancelAllOperations()
        syncToRemoteQueue.addOperation(SyncAllToRemoteOperation())
    }
    
    func syncAllFromRemote() {
        // order matters because of FK resolution
        LocationSvc().syncFromRemote()
        GroupSvc().syncFromRemote()
        TypeSvc().syncFromRemote()
        AccountSvc().syncFromRemote()
        ItemSvc().syncFromRemote()
    }
    
    func syncAllFromRemoteInBackground() {
        syncFromRemoteQueue.cancelAllOperations()
        syncFromRemoteQueue.addOperation(SyncAllFromRemoteOperation())
    }
    
    func notifySyncListeners(syncType: UserDataSyncType) {
        for listener in syncListeners {
            listener.notify(syncType)
        }
    }
    
    func registerSyncListener(listener: UserDataSyncListener) {
        syncListeners.insert(listener)
    }
    
    func ungregisterSyncListener(listener: UserDataSyncListener) {
        syncListeners.remove(listener)
    }

    
}

class SyncAllToRemoteOperation: NSOperation {
    override func main() {
        if self.cancelled {
            return
        }
        UserSvc().syncAllToRemote()
        UserSvc().notifySyncListeners(.To)
    }
}

class SyncAllFromRemoteOperation: NSOperation {
    override func main() {
        if self.cancelled {
            return
        }
        UserSvc().syncAllFromRemote()
        UserSvc().notifySyncListeners(.From)
    }
}

