//
//  Item.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite
#if os(iOS)
import Parse
#elseif os(OSX)
import ParseOSX
#endif


public func ==(a: Account, b: Account) -> Bool {
    return a.id == b.id
        && a.name == b.name
        && a.priority == b.priority
        && a.inactive == b.inactive
}

public class Account: Model, PFModel, SqlModel, CustomStringConvertible {
    
    public let modelType = ModelType.Account
    
    public let id: Int64?
    
    public let name: String
    public let priority: Int
    public let inactive: Bool
    
    let pf: PFObject?
    
    public var description: String {
        return "Account(id: \(id), name: \(name), priority: \(priority), inactive: \(inactive), pf: \(pf))"
    }
    
    public required init(id: Int64?, name: String, priority: Int, inactive: Bool, pf: PFObject? = nil) {
        self.id = id
        self.name = name
        self.priority = priority
        self.inactive = inactive
        self.pf = pf
    }
    
    convenience init(row: Row) {
        self.init(
            id: row.get(Fields.id),
            name: row.get(Fields.name),
            priority: row.get(Fields.priority),
            inactive: row.get(Fields.inactive))
    }
    
    convenience init(pf: PFObject) {
        self.init(
            id: pf.objectId.flatMap { ParseSvc().withParseId($0, ModelType.Account) }?.modelId,
            name: pf["name"] as! String,
            priority: pf["priority"] as! Int,
            inactive: pf["inactive"] as! Bool,
            pf: pf)
    }
    
    func toSetters() -> [Setter] {
        return [
            Fields.name <- name,
            Fields.priority <- priority,
            Fields.inactive <- inactive
        ]
    }
    
    func toPFObject() -> PFObject? {
        if id != nil {
            let npf = PFObject(withoutDataWithClassName: modelType.rawValue, objectId: pf?.objectId ?? parse()?.parseId)
            npf["name"] = name
            npf["priority"] = priority
            npf["inactive"] = inactive
            return npf
        }
        return nil
    }
    
    func parse() -> ParseModel? {
        return id.flatMap { ParseSvc().withModelId($0, modelType) }
    }
    
    public func copy(name: String? = nil, priority: Int? = nil, inactive: Bool? = nil) -> Account {
        return Account(
            id: id,
            name: name ?? self.name,
            priority: priority ?? self.priority,
            inactive: inactive ?? self.inactive)
    }
    
}