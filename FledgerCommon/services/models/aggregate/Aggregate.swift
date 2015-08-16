//
//  Aggregate.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/12/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation


public class Aggregate {
    
    public let model: ModelType?
    public let id: Int64?
    public let name: String
    public let value: Double
    public let active: Bool
    public let section: String?
    
    public required init(model: ModelType?, id: Int64?, name: String, value: Double, active: Bool = true, section: String? = nil) {
        self.model = model
        self.id = id
        self.name = name
        self.value = value
        self.active = active
        self.section = section
    }
    
    public func toString() -> String {
        let v = String(format: "%.2f", value)
        return "\(name) - \(v)"
    }
    
}