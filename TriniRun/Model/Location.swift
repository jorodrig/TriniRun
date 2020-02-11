//
//  Location.swift
//  TriniRun
//
//  Created by Joseph on 2/11/20.
//  Copyright © 2020 Coconut Tech LLc. All rights reserved.
//

import Foundation
import RealmSwift

/* Class to manage Realm Objects for locations for each run: this is used to create a polyline on the Map to show or track our path*/
class Location: Object{
    /* The following dynamic variables becomes assesors for the underlying Realm Database hence the use of Dynamic*/
    dynamic public private(set) var latitude = 0.0
    dynamic public private(set) var longitude = 0.0
    
    convenience init(latidude: Double, longitude: Double){
        self.init()
        self.latitude = latidude
        self.longitude = longitude
    }
    
    
    
}
