//
//  ItemService.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/12/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite


class ItemServiceImpl: PFItemService {
    
    private let id: Expression<Int64>
    
    required override init() {
        id = DatabaseSvc().items[Fields.id]
    }
    
    func modelType() -> ModelType {
        return ModelType.Item
    }
    
    internal func table() -> SchemaType {
        return DatabaseSvc().items.join(DatabaseSvc().types, on: Fields.typeId == DatabaseSvc().types[Fields.id])
    }
    
    func defaultOrder(query: SchemaType) -> SchemaType {
        return query.order(Fields.date.desc, table()[Fields.id].desc)
    }
    
    func baseFilter(query: SchemaType) -> SchemaType {
        return query.filter(Fields.amount != 0)
    }
    
    func select(filters: Filters?) -> [Item] {
        var elements: [Item] = []
        
        for row in DatabaseSvc().db.prepare(svc.baseQuery(filters)) {
            elements.append(Item(row: row))
        }
        
        return elements
    }
    
    override func getTransferPair(first: Item) -> Item? {
        return DatabaseSvc().db.pluck(table().filter(
            Fields.date == first.date &&
            Fields.comments == first.comments &&
            Fields.accountId != first.accountId &&
            Fields.typeId == TypeSvc().transferId
        )).map { Item(row: $0) }
    }
    
    override func getSum(item: Item, filters: Filters) -> Double {
        return DatabaseSvc().db.scalar(svc.baseQuery(filters, limit: false)
            .filter(
                Fields.date < item.date ||
                (Fields.date == item.date && id <= item.id!))
            .select(Fields.amount.sum)) ?? 0
    }
    
    override func getFiltersFromDefaults() -> ItemFilters {
        let filters = ItemFilters()
        
        filters.accountId = (NSUserDefaults.standardUserDefaults().valueForKey("filters.accountId") as? NSNumber)?.longLongValue
        filters.startDate = NSUserDefaults.standardUserDefaults().valueForKey("filters.startDate") as? NSDate
        filters.endDate = NSUserDefaults.standardUserDefaults().valueForKey("filters.endDate") as? NSDate
        filters.typeId = (NSUserDefaults.standardUserDefaults().valueForKey("filters.typeId") as? NSNumber)?.longLongValue
        filters.groupId = (NSUserDefaults.standardUserDefaults().valueForKey("filters.groupId") as? NSNumber)?.longLongValue
        
        filters.count = ItemSvc().defaultCount()
        filters.offset = 0
        
        return filters
    }
    
    override func defaultCount() -> Int {
        return 30
    }
    
}