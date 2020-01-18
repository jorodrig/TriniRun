//
//  Run.swift
//  TriniRun
//
//  Created by Joseph on 1/18/20.
//  Copyright © 2020 Coconut Tech LLc. All rights reserved.
//

import Foundation
import RealmSwift

class Run: Object {         //inherits from Object
    
    /* START CREATE REALM OBJECT*/
    dynamic public private(set) var id = ""             //sets a realm dynamic variable caled ID.  Required - dynamic allows the Realm Backend to dynamically update any and all realm database vars as needed.  Must be dynamic.  The set is data encapsulation.  In this case we can GET data from any source but can only SET within our database file.  Same for all the other variables
    
    dynamic public private(set) var date = NSDate()     //allows for easy sorting by date.  NSDate does have timestamp if needed for display
    dynamic public private(set) var pace = 0
    dynamic public private(set) var distance = 0.0
    dynamic public private(set) var duration = 0
    
    override class func primaryKey() -> String? {
        return "id"                                     //required: realm must know what the PK is. Any previously assigned VAR can be the PK
    }
    
    override class func indexedProperties() -> [String] { //Needed to allow searching. NOTE: Double Type is NOT allowed so cannot add <distance> variable
        return ["pace", "date", "duration"]
    }
    
    /* Convenience method here is like a constructor: Required*/
    convenience  init(pace: Int, distance: Double, duration: Int) {
        self.init()
        self.id = UUID().uuidString.lowercased()        //generates unique object IDs in lowercase - lowercase not required but I prefer
        self.date = NSDate()
        self.pace = pace
        self.distance = distance
        self.duration = duration
    }
    
    /* END CREATE REALM OBJECT*/
}
