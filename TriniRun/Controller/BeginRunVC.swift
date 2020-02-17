//
//  BeginRunVC.swift
//  TriniRun
//
//  Created by Joseph on 12/22/19.
//  Copyright © 2019 Coconut Tech LLc. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

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
        
        //print("Here are my runs: \(String(describing: Run.getAllRuns()))")
        print("Here are my runs: \(String(describing: Run.getAllRuns()))")

    }
    
    /*vieWillAppear and viewDidDisappear are needed as we will move back and forth
     between BeginRun and Current Run.*/
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        mapView.delegate = self
        manager?.startUpdatingLocation()
    }

    override func viewDidAppear(_ animated: Bool) {
        setUpMapView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
    }
    
    /* setUpMapView with check to see if polyline overlays already exist, if not , it will add the new overlay polyline, If exists an overlay polyline. Remove before adding the new polyline overlay*/
    func setUpMapView(){
        if  let overlay = addLastRunToMap(){                // get the last run that will be used to overlay the polyline.
            if mapView.overlays.count > 0 {                 // >0 means there are overlays on the map
                mapView.removeOverlays(mapView.overlays)    // remove existing overlay
            }
            mapView.addOverlay(overlay)                     //impliws else: add the current i.e. last run overlay polyline
            lastRunStack.isHidden = false
            lastRunBGView.isHidden = false
            lastRunCloseBrn.isHidden = false
        } else {
            lastRunStack.isHidden = true                        
            lastRunBGView.isHidden = true
            lastRunCloseBrn.isHidden = true
            centerMapOnUserLocation()
        }
        
    }
    
    /* Optional MKPloyline since we will not have a polyline when the app first runs*/
    func addLastRunToMap() -> MKPolyline? {
        guard let lastRun = Run.getAllRuns()?.first  else {return nil}
        paceLbl.text = lastRun.pace.formatTimeDurationToString()
        distanceLbl.text = "\(lastRun.distance.metersToMiles(places: 2)) mi "
        durationLbl.text = lastRun.duration.formatTimeDurationToString()
        
        //Next add the coordinates from our last run
        var coordinate = [CLLocationCoordinate2D]()     //empty array for last run coordinated defined below
        for location in lastRun.locations{
            coordinate.append(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        }
        
        mapView.userTrackingMode = .none //stop tracking user location
        mapView.setRegion(centerMapOnPrevRoute(locations: lastRun.locations), animated: true)  //centers the map on the prev run i.e. the last run completed
         
        return MKPolyline(coordinates: coordinate, count: lastRun.locations.count)
    }
    
    
    
    /* centerMapOnUserLocation tracks the user by following and created a default coordinate region */
    func centerMapOnUserLocation () {
        mapView.userTrackingMode = .follow
        let coordinateRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 500,longitudinalMeters: 500)
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    
    /* centerMapOnPrevRoute compares the user's current location to the user's previous run's location i.e. latitude and longitude and if current location coordinates is smaller than the previous run
     this function will reset*/
    func centerMapOnPrevRoute(locations: List<Location>) -> MKCoordinateRegion{
        guard let initialLoc = locations.first else { return MKCoordinateRegion()}   //first is the previous run
        var minLat = initialLoc.latitude
        var minLng = initialLoc.longitude
        var maxLat = minLat
        var maxLng = minLng
        
        for location in locations {
            minLat = min(minLat, location.latitude)   // compare our current location.latitude to the minLat then set minLat to the smaller
            minLng = min(minLng, location.longitude)  //ditto for longitude
            maxLat = max(maxLat, location.latitude)   //ditto for max latitude
            maxLng = max(maxLng, location.longitude)  //ditto for max longitude
        }
        
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (minLat + maxLat)/2, longitude: (minLng + maxLng)/2), span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat)*1.4, longitudeDelta: (maxLng - minLng)*1.4))
    }
    
    
    @IBAction func lastCloseBtnPressed(_ sender: Any) {
        
        lastRunStack.isHidden = true
        lastRunBGView.isHidden = true
        lastRunCloseBrn.isHidden = true
        centerMapOnUserLocation()
    }
    
    @IBAction func locationCenterBtnPressed(_ sender: Any) {
        
        centerMapOnUserLocation()
        
        
    }
    
}

extension BeginRunVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            checkLocationAuthStatus()
            mapView.showsUserLocation = true
            //mapView.userTrackingMode = .follow
        }
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)  //this is our polyline overlay on our map
        /* Setup the polyline properties as rendered on the map view*/
        renderer.strokeColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        renderer.lineWidth = 4
        return renderer
    }
    
    
}
