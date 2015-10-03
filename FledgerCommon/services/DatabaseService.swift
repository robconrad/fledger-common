//
//  DatabaseService.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/12/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite

protocol DatabaseService: Service {
    
    var db: Connection { get }
    
    var locations: SchemaType { get }
    var accounts: SchemaType { get }
    var groups: SchemaType { get }
    var types: SchemaType { get }
    var items: SchemaType { get }
    var parse: SchemaType { get }
    
    func createDatabaseDestructive()
    func loadDefaultData()
    func loadDefaultData(file: String)
    
}