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


public func ==(a: Item, b: Item) -> Bool {
    let x = a.id == b.id
        && a.accountId == b.accountId
        && a.typeId == b.typeId
        && a.locationId == b.locationId
    let y = a.locationId == b.locationId
        && a.amount == b.amount
        && a.date == b.date
        && a.comments == b.comments
    return x && y
}

public class Item: Model, PFModel, SqlModel, CustomStringConvertible {
    
    public let modelType = ModelType.Item
    
    public let id: Int64?
    public let accountId: Int64
    public let typeId: Int64
    public let locationId: Int64?
    public let amount: Double
    public let date: NSDate
    public let comments: String
    
    let pf: PFObject?
    
    public var description: String {
        return "Item(id: \(id), accountId: \(accountId), typeId: \(typeId), locationId: \(locationId), amount: \(amount), date: \(date), comments: \(comments), pf: \(pf))"
    }
    
    public required init(id: Int64?, accountId: Int64, typeId: Int64, locationId: Int64?, amount: Double, date: NSDate, comments: String, pf: PFObject? = nil) {
        self.id = id
        self.accountId = accountId
        self.typeId = typeId
        self.locationId = locationId
        self.amount = amount
        self.date = date
        self.comments = comments
        self.pf = pf
    }
    
    convenience init(row: Row) {
        self.init(
            id: row.get(DatabaseSvc().items[Fields.id]),
            accountId: row.get(Fields.accountId),
            typeId: row.get(Fields.typeId),
            locationId: row.get(Fields.locationId),
            amount: row.get(Fields.amount),
            date: row.get(Fields.date),
            comments: row.get(Fields.comments))
    }
    
    convenience init(pf: PFObject) {
        self.init(
            id: pf.objectId.flatMap { ParseSvc().withParseId($0, ModelType.Item) }?.modelId,
            accountId: ParseSvc().withParseId(pf["accountId"] as! String, ModelType.Account)!.modelId,
            typeId: ParseSvc().withParseId(pf["typeId"] as! String, ModelType.Typ)!.modelId,
            locationId: (pf["locationId"] as? String).map { ParseSvc().withParseId($0, ModelType.Location)!.modelId },
            amount: pf["amount"] as! Double,
            date: pf["date"] as! NSDate,
            comments: pf["comments"] as! String,
            pf: pf)
    }
    
    func toSetters() -> [Setter] {
        return [
            Fields.accountId <- accountId,
            Fields.typeId <- typeId,
            Fields.locationId <- locationId,
            Fields.amount <- amount,
            Fields.date <- date,
            Fields.comments <- comments
        ]
    }
    
    func toPFObject() -> PFObject? {
        if let parseAccountId = account().parse()!.parseId, parseTypeId = type().parse()!.parseId {
            let myLocation = location()
            let parseLocationId = myLocation.flatMap { $0.parse()!.parseId }
            if myLocation != nil && parseLocationId == nil {
                return nil
            }
            let npf = PFObject(withoutDataWithClassName: modelType.rawValue, objectId: pf?.objectId ?? parse()?.parseId)
            npf["accountId"] = parseAccountId
            npf["typeId"] = parseTypeId
            npf["locationId"] = parseLocationId ?? NSNull()
            npf["amount"] = amount
            npf["date"] = date
            npf["comments"] = comments
            return npf
        }
        return nil
    }
    
    func parse() -> ParseModel? {
        return id.flatMap { ParseSvc().withModelId($0, modelType) }
    }
    
    public func copy(accountId: Int64? = nil, typeId: Int64? = nil, locationId: Int64? = nil, amount: Double? = nil, date: NSDate? = nil, comments: String? = nil) -> Item {
        return Item(
            id: id,
            accountId: accountId ?? self.accountId,
            typeId: typeId ?? self.typeId,
            locationId: locationId ?? self.locationId,
            amount: amount ?? self.amount,
            date: date ?? self.date,
            comments: comments ?? self.comments)
    }
    
    public func withId(id: Int64?) -> Item {
        return Item(
            id: id,
            accountId: accountId,
            typeId: typeId,
            locationId: locationId,
            amount: amount,
            date: date,
            comments: comments)
    }
    
    public func clear(locationId: Bool = false) -> Item {
        return Item(
            id: id,
            accountId: accountId,
            typeId: typeId,
            locationId: locationId ? nil : self.locationId,
            amount: amount,
            date: date,
            comments: comments)
    }
    
    public func account() -> Account {
        return AccountSvc().withId(accountId)!
    }
    
    public func type() -> Type {
        return TypeSvc().withId(typeId)!
    }
    
    public func group() -> Group {
        return GroupSvc().withTypeId(typeId)!
    }
    
    public func location() -> Location? {
        return locationId.flatMap { LocationSvc().withId($0) }
    }
    
    public func isTransfer() -> Bool {
        return typeId == TypeSvc().transferId
    }
    
}
