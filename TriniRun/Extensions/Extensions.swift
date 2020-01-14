//
//  Extensions.swift
//  TriniRun
//
//  Created by Joseph on 1/14/20.
//  Copyright © 2020 Coconut Tech LLc. All rights reserved.
//

import Foundation

extension Double {
    func metersToMiles(places: Int) -> Double{
        let divisor = pow(10.0, Double(places))
    return ((self / 1609.34)  * divisor).rounded() / divisor           //self here is runDistance in CurrentRunVC.swift
    
    }
}
