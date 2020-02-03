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
    
    /* START CREATE REALM OBJECT: Data Model to manage data for runs.
       NOTE: With Realm - we MUST create a NEW instance EVERYTIME we WRITE and everytimg we READ
       ALSO: Writes to Realm is asynchronous - so we need to take it off the main Thread - and instead use a serial dispatch  asynchronous queue
       we need to be sure we are calling it from the same Thread */
    @objc dynamic public private(set) var id: String = ""             /*sets a realm dynamic variable caled ID.  Required - dynamic allows the Realm Backend to dynamically update any and all realm database vars as needed.  Must be dynamic.  The set is data encapsulation.  In this case we can GET data from any source but can only SET within our database file.  Same for all the other variables*/
    /*NOTE: Added @objc to Realm vars as without app crashed due to primary key not set on object run error */
    @objc dynamic public private(set) var date = NSDate()     //allows for easy sorting by date.  NSDate does have timestamp if needed for display
    @objc dynamic public private(set) var pace = 0
    @objc dynamic public private(set) var distance = 0.0
    @objc dynamic public private(set) var duration = 0
    
    override class func primaryKey() -> String {
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
    
    /* Static func addRunToRealm -CALLED in endRun() in CurrentRunVC.swift - create static as we want a single instance that won't be overwritten */
    static func addRunToRealm(pace: Int, distance: Double, duration: Int){
        REALM_QUEUE.sync {                          //Created in Utilities->Constants - this allows us to run Realm on its own async Thread
       
        let run = Run(pace: pace, distance: distance, duration: duration) //passed in from previous VC
        
        do {
            let realm = try Realm()
            print(Realm.Configuration.defaultConfiguration.fileURL!)


            try realm.write {
                realm.add(run)
                try realm.commitWrite()             //not mandatory but preferred to confirm the commit
            }
            } catch{
            debugPrint("Error adding run to realm!")
        }
      }
    }
    
    
    static func getAllRuns() ->Results<Run>? {
        print("In Get All Runs in Run.swift model")
        do {
            let realm = try Realm()
            var runs = realm.objects(Run.self)
            //let runs = realm.objects(Run.self)  //test

            return runs
        }catch{
            print("No data found in realm db")
            print(Realm.Configuration.defaultConfiguration.fileURL!)

            return nil                            //Return Nil if there is no data in database
        }
        
    }
    
    /* END CREATE REALM OBJECT*/
}
