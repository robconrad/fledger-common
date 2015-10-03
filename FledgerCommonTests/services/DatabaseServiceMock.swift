//
//  DatabaseServiceMock.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/2/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Foundation
import SQLite

class DatabaseServiceMock: DatabaseService {
    
    let db: Connection
    
    let locations: SchemaType
    let accounts: SchemaType
    let groups: SchemaType
    let types: SchemaType
    let items: SchemaType
    let parse: SchemaType
    
    required init(_ username: String) {
        
        if username.characters.count < 3 {
            fatalError("must supply valid username")
        }
        
        let usernameHash = username.md5()
        
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        let dbPath = "\(path)/db-\(usernameHash).sqlite3"
        let createdKey = "created-\(usernameHash)"
        
        do {
            db = try Connection(dbPath)
        }
        catch {
            fatalError("failed to create db connection")
        }
        
        #if DEBUG
            db.trace(print)
        #endif
        
        locations = Table("locations")
        accounts = Table("accounts")
        groups = Table("groups")
        types = Table("types")
        items = Table("items")
        parse = Table("parse")
        
        db.createFunction("distance", deterministic: true) { args in
            if let lat1 = args[0] as? Double, long1 = args[1] as? Double, lat2 = args[2] as? Double, long2 = args[3] as? Double {
                let piOver180 = 0.01745327
                let lat1rad = lat1 * piOver180
                let lat2rad = lat2 * piOver180
                let long1rad = long1 * piOver180
                let long2rad = long2 * piOver180
                return acos(sin(lat1rad) * sin(lat2rad) + cos(lat1rad) * cos(lat2rad) * cos(long2rad - long1rad)) * 6378.1
            }
            return nil
        }
        
        if !NSUserDefaults.standardUserDefaults().boolForKey(createdKey) {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: createdKey)
            createDatabaseDestructive()
            //loadDefaultData()
        }
    }
    
    func createDatabaseDestructive() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let url = bundle.URLForResource("schema", withExtension: "sql")
        let schema = NSData(contentsOfURL: url!)
        let sql = NSString(data: schema!, encoding: NSASCIIStringEncoding) as! String
        do {
            try db.execute(sql)
        }
        catch {
            fatalError("failed to createDatabaseDestructive")
        }
    }
    
    func loadDefaultData() {
        loadDefaultData("data-lite")
    }
    func loadDefaultData(file: String) {
        let bundle = NSBundle(forClass: self.dynamicType)
        let url = bundle.URLForResource(file, withExtension: "sql")
        let data = NSData(contentsOfURL: url!)
        let sql = NSString(data: data!, encoding: NSASCIIStringEncoding) as! String
        do {
            try db.execute(sql)
        }
        catch {
            fatalError("failed to loadDefaultData(\(file))")
        }
    }
    
}