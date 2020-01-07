//
//  BeginRunVC.swift
//  TriniRun
//
//  Created by Joseph on 12/22/19.
//  Copyright © 2019 Coconut Tech LLc. All rights reserved.
//

import UIKit
import MapKit


class BeginRunVC: LocationVC {  //inherit LocationVC which already inherits viewcontroller

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
        mapView.delegate = self
    }
    
    /*vieWillAppear and viewDidDisappear are needed as we will move back and forth
     between BeginRun and Current Run.*/
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        manager?.startUpdatingLocation()
    }

    override func viewDidDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
    }
    
    @IBAction func locationCenterBtnPressed(_ sender: Any) {
        
    }
    
}

extension BeginRunVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            checkLocationAuthStatus()
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
        }
    }
    
    
}
