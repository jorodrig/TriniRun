//
//  CurrentRunVC.swift
//  TriniRun
//
//  Created by Joseph on 1/8/20.
//  Copyright © 2020 Coconut Tech LLc. All rights reserved.
//

import UIKit

class CurrentRunVC: LocationVC {  //inherits from LocationVC which inherits from UIViewController

    @IBOutlet weak var swipeBGImageView: UIImageView!
    
    @IBOutlet weak var sliderImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* swipeGesture is used to control the custom slider*/
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(endRunSwiped(sender:)))
        sliderImageView.addGestureRecognizer(swipeGesture) //Recognize slidegestures
        sliderImageView.isUserInteractionEnabled = true  //allow user interaction
        swipeGesture.delegate = self as? UIGestureRecognizerDelegate //must have
        
    }
    
/* endRunSwiped is used to end the run action - user will swipe or slide left to right to end or use pause button*/
    @objc func endRunSwiped(sender: UIPanGestureRecognizer){
        /* the constants below are used to adjust the slider relative to its background view
         not the main view controller.*/
        let minAdjust: CGFloat = 80
        let maxAdjust: CGFloat = 128
        if let sliderView = sender.view{
            if sender.state == UIGestureRecognizer.State.began || sender.state == UIGestureRecognizer.State.changed{
                let translation = sender.translation(in: self.view)
                if sliderView.center.x >= (swipeBGImageView.center.x - minAdjust) && sliderView.center.x <= (swipeBGImageView.center.x + maxAdjust){
                    sliderView.center.x = sliderView.center.x + translation.x
                    
                } else if sliderView.center.x >= swipeBGImageView.center.x + maxAdjust{
                    sliderView.center.x = swipeBGImageView.center.x + maxAdjust
                    //End Run Code goes here
                    dismiss(animated: true, completion: nil)  //return to the main view as run has ended
                } else{
                    sliderView.center.x = swipeBGImageView.center.x - minAdjust
                }
                sender.setTranslation(CGPoint.zero, in: self.view)
            }
        }
        
    }

}
