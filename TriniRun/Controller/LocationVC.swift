//
//  LocationVC.swift
//  TriniRun
//
//  Created by Joseph on 1/7/20.
//  Copyright © 2020 Coconut Tech LLc. All rights reserved.
//

import UIKit
import MapKit

class LocationVC: UIViewController, MKMapViewDelegate{

    var manager: CLLocationManager?         //optional for the location manager
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CLLocationManager()  //instantiate the location manager
        manager?.desiredAccuracy = kCLLocationAccuracyBest  // Best is used for walking or running, other options for driving etc can be less than Best.
        manager?.activityType = .fitness  //.automotiveNavigation is also available.

    }
    
    func checkLocationAuthStatus(){
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse{  //if not already authorized for location
            manager?.requestWhenInUseAuthorization() //prompt the user for location auth
        }
    }


}
