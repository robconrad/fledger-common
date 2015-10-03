//
//  ParseService.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/10/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Foundation
import SQLite
#if os(iOS)
import Parse
#elseif os(OSX)
import ParseOSX
#endif


class ParseServiceImpl: ParseService {
    
    func select(filters: ParseFilters?) -> [ParseModel] {
        var query = DatabaseSvc().parse
        if let f = filters {
            query = f.toQuery(query, limit: true)
        }
        
        var elements: [ParseModel] = []
        
        for row in DatabaseSvc().db.prepare(query) {
            elements.append(ParseModel(row: row))
        }
        
        return elements
    }
    
    func withModelId(id: Int64, _ modelType: ModelType) -> ParseModel? {
        return DatabaseSvc().db.pluck(DatabaseSvc().parse.filter(Fields.model == modelType.rawValue && Fields.modelId == id)).map { ParseModel(row: $0) }
    }
    
    func withParseId(id: String, _ modelType: ModelType) -> ParseModel? {
        return DatabaseSvc().db.pluck(DatabaseSvc().parse.filter(Fields.model == modelType.rawValue && Fields.parseId == id)).map { ParseModel(row: $0) }
    }
    
    func markSynced(id: Int64, _ modelType: ModelType, _ pf: PFObject) -> Bool {
        do {
            if let parseId = pf.objectId {
                let query = DatabaseSvc().parse.filter(Fields.model == modelType.rawValue && Fields.modelId == id)
                let rows = try DatabaseSvc().db.run(query.update([
                    Fields.synced <- true,
                    Fields.parseId <- parseId,
                    Fields.updatedAt <- NSDateTime(pf.updatedAt!)
                ]))
                if rows != 1 {
                    throw NSError(domain: "", code: 1, userInfo: nil)
                }
            }
        }
        catch {
            return false
        }
        return true
    }
    
    func save(convertible: PFObjectConvertible) -> PFObject? {
        if let pf = convertible.toPFObject() {
            pf.ACL = PFACL(user: PFUser.currentUser()!)
            pf.save()
            print("Save of PFObject for \(convertible) returned \(pf.objectId)")
            return pf
        }
        return nil
    }
    
    // TODO: ***REMOVED***
    func remote(modelType: ModelType, updatedOnly: Bool) -> [PFObject]? {
        let lastSyncedRow = DatabaseSvc().db.pluck(DatabaseSvc().parse.filter(Fields.model == modelType.rawValue).order(Fields.updatedAt.desc))
        var bufferRows = [String]()
        let query = PFQuery(className: modelType.rawValue)
        if let lastRow = lastSyncedRow {
            let lastDateFactory = NSDate.dateByAddingTimeInterval(lastRow.get(Fields.updatedAt)?.date ?? NSDate(timeIntervalSince1970: 0))
            let updatedAtLeast = lastDateFactory(-60)
            
            for row in DatabaseSvc().db.prepare(DatabaseSvc().parse.filter(Fields.model == modelType.rawValue && Fields.updatedAt >= NSDateTime(updatedAtLeast))) {
                if let id = row.get(Fields.parseId) {
                    bufferRows.append(id)
                }
            }
            
            // query for records within one minute of the last updated record that are not themselves the last updated record
            query.whereKey("updatedAt", greaterThanOrEqualTo: updatedAtLeast)
            query.whereKey("objectId", notContainedIn: [lastRow.get(Fields.parseId) ?? ""])
        }
        let result = query.findObjects() as? [PFObject]
        print("Remote query for PFObjects of \(modelType) lastSyncedRow (\(lastSyncedRow.flatMap { $0.get(Fields.updatedAt)?.date }), \(lastSyncedRow?.get(Fields.parseId))) returned \(result?.count ?? 0) rows")
        
        //for parseId in bufferRows {
            //result!.find { $0.parseId == parseId }
        //}
        
        return result
    }
        
    func isLoggedIn() -> Bool {
        return PFUser.currentUser() != nil
    }
    
    func login(email: String, _ password: String) -> Bool {
        return PFUser.logInWithUsername(email, password: password) != nil
    }
    
    func logout() {
        PFUser.logOut()
    }
    
    func signup(email: String, _ password: String) -> Bool {
        let user = PFUser()
        user.username = email
        user.password = password
        user.email = email
        
        return user.signUp()
    }
    
}
