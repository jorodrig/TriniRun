//
//  RealmConfig.swift
//  TriniRun
//
//  Created by Joseph on 2/12/20.
//  Copyright © 2020 Coconut Tech LLc. All rights reserved.
//

import Foundation
import RealmSwift

class RealmConfig {
    
    //static variable to store realm configuration
    static var runDataConfig: Realm.Configuration {
    let realmPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(REALM_RUN_CONFIG)
        /* */
        let config = Realm.Configuration(
            fileURL: realmPath,                             //is the realmPath that will be on the user's device
            schemaVersion: 0,                               //The DB schema version - initiall set to zero but will be updated every time the Realm DB is updated
            migrationBlock: { migration, oldSchemaVersion in   //start migrationBlock swift closure
                if (oldSchemaVersion < 0) {                 //
                    //Nothing to do
                    //realm will automatically detect new properties and remove properties
                    //This is where more complex data migrations with be coded such as changing DB types etc.
                    //so long as the schemaVersion is different from the initial or previous scheme version, these changes will be made
                }
                
            })
        return config

        }
}
    
