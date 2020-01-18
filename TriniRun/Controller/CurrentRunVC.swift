//
//  CurrentRunVC.swift
//  TriniRun
//
//  Created by Joseph on 1/8/20.
//  Copyright © 2020 Coconut Tech LLc. All rights reserved.
//

import UIKit
import MapKit

class CurrentRunVC: LocationVC {  //inherits from LocationVC which inherits from UIViewController

    @IBOutlet weak var swipeBGImageView: UIImageView!
    @IBOutlet weak var sliderImageView: UIImageView!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var paceLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var pauseBtn: UIButton!
    
    
    var startLocation: CLLocation!              //must be forced unwrap as should not be nil once started
    var lastLocation: CLLocation!               //ditto
    var runDistance = 0.0                       //ditto
    var counter = 0                             // used in Timer function - represents seconds
    var timer = Timer()
    var pace = 0                                //Used in pace function seconds/miles
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* swipeGesture is used to control the custom slider*/
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(endRunSwiped(sender:)))
        sliderImageView.addGestureRecognizer(swipeGesture) //Recognize slidegestures
        sliderImageView.isUserInteractionEnabled = true  //allow user interaction
        swipeGesture.delegate = self as? UIGestureRecognizerDelegate //must have
        
    }
    
    /* Helps the reload the view after initial Appear when going back and forth ViewControllers etc*/
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        manager?.distanceFilter = 10 //Meters
        startRun()
        }
    
    func startRun(){
        manager?.startUpdatingLocation()
        startTimer()
        pauseBtn.setImage(#imageLiteral(resourceName: "pauseButton"), for: .normal)

    }
        
    func endRun(){
        manager?.stopUpdatingLocation()
    }
    
    func pauseRun(){
        startLocation = nil
        lastLocation = nil
        timer.invalidate()
        manager?.stopUpdatingLocation()
        pauseBtn.setImage(#imageLiteral(resourceName: "resumeButton"), for: .normal)
    }

    func startTimer(){
        durationLbl.text = counter.formatTimeDurationToString()               //called once per run - set it to zero as default for each run
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter(){
        counter += 1
        durationLbl.text = counter.formatTimeDurationToString()
    }
    
    
    func calculatePace(time seconds: Int, miles: Double) -> String{
        pace = Int(Double(seconds) / miles)
        return pace.formatTimeDurationToString()
    }
    
    
    
    
    @IBAction func pauseBtnPressed(_ sender: Any) {
        if timer.isValid{
            pauseRun()
        }else{
            startRun()
        }
        
    }
    
    
    
/* endRunSwiped is used to end the run action - user will swipe or slide left to right to end or use pause button*/
    @objc func endRunSwiped(sender: UIPanGestureRecognizer){
        /* the constants below are used to adjust the slider relative to its background view
         not the main view controller.*/
        let minAdjust: CGFloat = 80
        let maxAdjust: CGFloat = 128
        if let sliderView = sender.view{  //below starts the completion handler for the slider swipe button
            if sender.state == UIGestureRecognizer.State.began || sender.state == UIGestureRecognizer.State.changed{
                let translation = sender.translation(in: self.view)
                if sliderView.center.x >= (swipeBGImageView.center.x - minAdjust) && sliderView.center.x <= (swipeBGImageView.center.x + maxAdjust){
                    sliderView.center.x = sliderView.center.x + translation.x
                    
                } else if sliderView.center.x >= swipeBGImageView.center.x + maxAdjust{
                    sliderView.center.x = swipeBGImageView.center.x + maxAdjust
                    endRun()                                  // Data is added to realm via this function
                    dismiss(animated: true, completion: nil)  //return to the main view as run has ended
                } else{
                    sliderView.center.x = swipeBGImageView.center.x - minAdjust
                }
                sender.setTranslation(CGPoint.zero, in: self.view)
            }else if sender.state == UIGestureRecognizer.State.ended{           //End by swiping to the right and return to previous screen - the caller
                UIView.animate(withDuration: 0.1, animations:{
                sliderView.center.x = self.swipeBGImageView.center.x - minAdjust  //need 'self' here as we are in a completion handler
                })
            }
        }
    }
}

/*Used to Track the device for location - to see if we are still authorized to track our location
 if not will call checkLocationAuthStatus in LocationVC */
extension CurrentRunVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            checkLocationAuthStatus()
        }
    }
    
    /* Location manager is used to keep track of location*/
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startLocation == nil {                                              //is True when apps starts
            startLocation = locations.first                                    //assign the first loaction when motion detected
        }else if let location = locations.last{                                //the last location detected in CLLocation
            runDistance += lastLocation.distance(from: location)               //is the last location in the CLLocaiton array
            distanceLbl.text = "\(runDistance.metersToMiles(places: 2))"       //update the Distance label
            if counter > 0 && runDistance > 0 {
                paceLbl.text = calculatePace(time: counter, miles: runDistance.metersToMiles(places: 2))
            }
        }
        lastLocation = locations.last
    }
}
