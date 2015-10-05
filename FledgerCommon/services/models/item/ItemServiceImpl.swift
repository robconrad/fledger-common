//
//  ItemService.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/12/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite


class ItemServiceImpl: ItemService, HasShieldedPersistenceEngine {
    
    let engine: ShieldedPersistenceEngine<Item, StandardPersistenceEngine<Item>>
    
    private let table: SchemaType
    private let id: Expression<Int64>
    
    required init() {
        id = DatabaseSvc().items[Fields.id]
        
        let _table = DatabaseSvc().items.join(DatabaseSvc().types, on: Fields.typeId == DatabaseSvc().types[Fields.id])
        table = _table
        
        engine = ShieldedPersistenceEngine(engine: StandardPersistenceEngine<Item>(
            modelType: ModelType.Item,
            fromPFObject: { pf in Item(pf: pf) },
            fromRow: { row in Item(row: row) },
            table: table,
            defaultOrder: { q in q.order(Fields.date.desc, _table[Fields.id].desc) },
            baseFilter: { q in q.filter(Fields.amount != 0) }
        ))
    }
    
    func getTransferPair(first: Item) -> Item? {
        return DatabaseSvc().db.pluck(table.filter(
            Fields.date == first.date &&
            Fields.comments == first.comments &&
            Fields.accountId != first.accountId &&
            Fields.typeId == TypeSvc().transferId
        )).map { Item(row: $0) }
    }
    
    func getSum(item: Item, filters: Filters) -> Double {
        return DatabaseSvc().db.scalar(table.filter(
                Fields.date < item.date ||
                (Fields.date == item.date && id <= item.id!))
            .select(Fields.amount.sum)) ?? 0
    }
    
    func getFiltersFromDefaults() -> ItemFilters {
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
    
    func defaultCount() -> Int {
        return 30
    }
    
}