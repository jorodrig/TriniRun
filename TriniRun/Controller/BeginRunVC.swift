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
    @IBOutlet weak var lastRunCloseBrn: UIButton!
    @IBOutlet weak var paceLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var lastRunBGView: UIView!
    @IBOutlet weak var lastRunStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
        mapView.delegate = self
        
        //print("Here are my runs: \(String(describing: Run.getAllRuns()))")
        print("Here are my runs: \(String(describing: Run.getAllRuns()))")

    }
    
    /*vieWillAppear and viewDidDisappear are needed as we will move back and forth
     between BeginRun and Current Run.*/
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        manager?.startUpdatingLocation()
        getLastRun()
    }

    override func viewDidDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
    }
    
    func getLastRun(){
        guard let lastRun = Run.getAllRuns()?.first else {
            lastRunStack.isHidden = true                        //if there are no runs just hide
            lastRunBGView.isHidden = true
            lastRunCloseBrn.isHidden = true
            return
        }
        /* If there are runs show run features*/
        lastRunStack.isHidden = false
        lastRunBGView.isHidden = false
        lastRunCloseBrn.isHidden = false
        paceLbl.text = lastRun.pace.formatTimeDurationToString()
        distanceLbl.text = "\(lastRun.distance.metersToMiles(places: 2)) mi "
        durationLbl.text = lastRun.duration.formatTimeDurationToString()
              
            }
    
    
    @IBAction func lastCloseBtnPressed(_ sender: Any) {
        
        lastRunStack.isHidden = true
        lastRunBGView.isHidden = true
        lastRunCloseBrn.isHidden = true
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
