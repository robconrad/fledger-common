//
//  Model.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation


public protocol Model: Equatable {
    
    var id: Int64? { get }
    var modelType: ModelType { get }
    
}
