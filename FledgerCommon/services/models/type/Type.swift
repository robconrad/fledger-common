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


public func ==(a: Type, b: Type) -> Bool {
    return a.id == b.id
        && a.groupId == b.groupId
        && a.name == b.name
}

public class Type: Model, PFModel, SqlModel, CustomStringConvertible {
    
    public let modelType = ModelType.Typ
    
    public let id: Int64?
    public let groupId: Int64
    
    public let name: String
    
    let pf: PFObject?
    
    public var description: String {
        return "Type(id: \(id), groupId: \(groupId), name: \(name), pf: \(pf))"
    }
    
    public required init(id: Int64?, groupId: Int64, name: String, pf: PFObject? = nil) {
        self.id = id
        self.groupId = groupId
        self.name = name
        self.pf = pf
    }
    
    convenience init(row: Row) {
        self.init(
            id: row.get(Fields.id),
            groupId: row.get(Fields.groupId),
            name: row.get(Fields.name))
    }
    
    convenience init(pf: PFObject) {
        self.init(
            id: pf.objectId.flatMap { ParseSvc().withParseId($0, ModelType.Typ) }?.modelId,
            groupId: ParseSvc().withParseId(pf["groupId"] as! String, ModelType.Group)!.modelId,
            name: pf["name"] as! String,
            pf: pf)
    }
    
    func toSetters() -> [Setter] {
        return [
            Fields.name <- name,
            Fields.groupId <- groupId
        ]
    }
    
    func toPFObject() -> PFObject? {
        if let myId = id, myGroupId = GroupSvc().withId(groupId)?.parse()!.parseId {
            let npf = PFObject(withoutDataWithClassName: modelType.rawValue, objectId: pf?.objectId ?? parse()?.parseId)
            npf["name"] = name
            npf["groupId"] = myGroupId
            return npf
        }
        return nil
    }
    
    func parse() -> ParseModel? {
        return id.flatMap { ParseSvc().withModelId($0, modelType) }
    }
    
    public func copy(groupId: Int64? = nil, name: String? = nil) -> Type {
        return Type(
            id: id,
            groupId: groupId ?? self.groupId,
            name: name ?? self.name)
    }
    
    public func group() -> Group {
        return GroupSvc().withTypeId(id!)!
    }
    
}