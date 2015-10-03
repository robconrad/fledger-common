//
//  Manager.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite
#if os(iOS)
import Parse
#elseif os(OSX)
import ParseOSX
#endif


class StandardModelServiceImpl<M where M: PFModel, M: SqlModel>: ModelService {
    
    func modelType() -> ModelType {
        fatalError(__FUNCTION__ + " must be implemented")
    }
    
    // I hate Swift.
    // When this is implemented properly in the end ModelService classes it generates EXC_BAD_ACCESS for no goddamn reason.
    func fromPFObject(pf: PFObject) -> M {
        switch modelType() {
        case .Location: return Location(pf: pf) as! M
        case .Group: return Group(pf: pf) as! M
        case .Typ: return Type(pf: pf) as! M
        case .Account: return Account(pf: pf) as! M
        case .Item: return Item(pf: pf) as! M
        }
    }
    
    internal func table() -> SchemaType {
        fatalError(__FUNCTION__ + " must be implemented")
    }
    
    func withId(id: Int64) -> M? {
        fatalError(__FUNCTION__ + " must be implemented")
    }
    
    func all() -> [M] {
        return select(nil)
    }
    
    func defaultOrder(query: SchemaType) -> SchemaType {
        return query.order(Fields.id.desc)
    }
    
    func baseFilter(query: SchemaType) -> SchemaType {
        return query
    }
    
    func baseQuery(filters: Filters? = nil, limit: Bool = true) -> SchemaType {
        var query = defaultOrder(baseFilter(table()))
        
        if let f = filters {
            query = f.toQuery(query, limit: limit, table: table())
        }
        
        return query
    }
    
    func select(filters: Filters?) -> [M] {
        fatalError(__FUNCTION__ + " must be implemented")
    }
    
    func count(filters: Filters?) -> Int {
        return DatabaseSvc().db.scalar(baseQuery(filters, limit: false).count)
    }
    
    func insert(e: M) -> Int64? {
        return insert(e, fromRemote: false)
    }
    
    internal func insert(e: M, fromRemote: Bool) -> Int64? {
        var id: Int64?
        
        if fromRemote {
            assert(e.pf != nil, "pf may not be empty if insert is fromRemote")
        }
        
        do {
            try DatabaseSvc().db.transaction { _ in
                
                let modelId = try DatabaseSvc().db.run(self.table().insert(e.toSetters()))
                id = modelId
                
                try DatabaseSvc().db.run(DatabaseSvc().parse.insert([
                    Fields.model <- self.modelType().rawValue,
                    Fields.modelId <- modelId,
                    Fields.parseId <- e.pf?.objectId,
                    Fields.synced <- fromRemote,
                    Fields.deleted <- false,
                    Fields.updatedAt <- e.pf?.updatedAt.map { NSDateTime($0) }
                ]))
            }
        }
        catch {
            print("caught error")
            return nil
        }
        
        if !fromRemote {
            UserSvc().syncAllToRemoteInBackground()
        }
        
        return id
    }
    
    func update(e: M) -> Bool {
        return update(e, fromRemote: false)
    }
    
    internal func update(e: M, fromRemote: Bool) -> Bool {
        do {
            try DatabaseSvc().db.transaction { _ in
                let modelRows = try DatabaseSvc().db.run(self.table().filter(Fields.id == e.id!).update(e.toSetters()))
                
                if modelRows == 1 {
                    let query: QueryType = DatabaseSvc().parse.filter(Fields.model == self.modelType().rawValue && Fields.modelId == e.id!)
                    var setters = [Fields.synced <- fromRemote]
                    if let parseId = e.pf?.objectId, updatedAt = e.pf?.updatedAt {
                        setters.append(Fields.parseId <- parseId)
                        setters.append(Fields.updatedAt <- NSDateTime(updatedAt))
                    }
                    if try DatabaseSvc().db.run(query.update(setters)) != 1 {
                        throw NSError(domain: "", code: 1, userInfo: nil)
                    }
                }
                else {
                    throw NSError(domain: "", code: 1, userInfo: nil)
                }
            }
        }
        catch {
            print("caught error")
            return false
        }
        
        if !fromRemote {
            UserSvc().syncAllToRemoteInBackground()
        }
        
        return true
    }
    
    func delete(e: M) -> Bool {
        return delete(e.id!)
    }
    
    func delete(id: Int64) -> Bool {
        return delete(id, fromRemote: false)
    }
    
    internal func delete(id: Int64, fromRemote: Bool, updatedAt: NSDate? = nil) -> Bool {
        do {
            try DatabaseSvc().db.transaction { _ in
                let modelRows = try DatabaseSvc().db.run(self.table().filter(Fields.id == id).delete())
                
                if modelRows == 1 {
                    let query: QueryType = DatabaseSvc().parse.filter(Fields.model == self.modelType().rawValue && Fields.modelId == id)
                    var setters = [
                        Fields.synced <- fromRemote,
                        Fields.deleted <- true
                    ]
                    if let date = updatedAt {
                        setters.append(Fields.updatedAt <- NSDateTime(date))
                    }
                    if try DatabaseSvc().db.run(query.update(setters)) != 1 {
                        throw NSError(domain: "", code: 1, userInfo: nil)
                    }
                }
                else {
                    throw NSError(domain: "", code: 1, userInfo: nil)
                }
            }
        }
        catch {
            print("caught error")
            return false
        }
        
        if !fromRemote {
            UserSvc().syncAllToRemoteInBackground()
        }
        
        return true
    }
    
    func invalidate() {
        // standard model always talks to db and thus doesn't require invalidation
    }
    
    func syncToRemote() {
        let parseFilters = ParseFilters()
        parseFilters.synced = false
        parseFilters.modelType = modelType()
        let parseModels = ParseSvc().select(parseFilters)
        
        let modelFilters = Filters()
        modelFilters.ids = Set(parseModels.filter { !$0.deleted }.map { $0.modelId })
        for model in select(modelFilters) {
            if let pf = ParseSvc().save(model) {
                ParseSvc().markSynced(model.id!, modelType(), pf)
            }
        }
        
        let deletedModels = parseModels.filter { $0.deleted }.map { DeletedModel(id: $0.modelId, parseId: $0.parseId!, modelType: self.modelType()) }
        for model in deletedModels {
            if let pf = ParseSvc().save(model) {
                ParseSvc().markSynced(model.id, modelType(), pf)
            }
        }
    }
    
    func syncFromRemote() {
        var pfObjects: [PFObject] = ParseSvc().remote(modelType(), updatedOnly: true) ?? []
        // sort by date ascending so that we don't miss any if this gets interrupted and we try syncIncoming again
        pfObjects.sortInPlace { ($0.updatedAt ?? NSDate()).compare($1.updatedAt!) == .OrderedAscending }
        let models = pfObjects.map { self.fromPFObject($0) }
        for i in 0..<pfObjects.count {
            let model = models[i]
            if model.id == nil {
                if let id = insert(model, fromRemote: true) {
                    if (pfObjects[i]["deleted"] as? Bool) == true {
                        if !delete(id, fromRemote: true) {
                            fatalError(__FUNCTION__ + " failed to delete \(model)")
                        }
                    }
                }
                else {
                    fatalError(__FUNCTION__ + " failed to insert \(model)")
                }
            }
            else {
                if (pfObjects[i]["deleted"] as? Bool) == true {
                    if !delete(model.id!, fromRemote: true, updatedAt: pfObjects[i].updatedAt) {
                        fatalError(__FUNCTION__ + " failed to delete \(model)")
                    }
                }
                else {
                    if !update(model, fromRemote: true) {
                        fatalError(__FUNCTION__ + " failed to update \(model)")
                    }
                }
            }
        }
        
        invalidate()
    }
    
}
