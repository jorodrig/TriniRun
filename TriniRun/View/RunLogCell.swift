//
//  RunLogCell.swift
//  TriniRun
//
//  Created by Joseph on 2/8/20.
//  Copyright © 2020 Coconut Tech LLc. All rights reserved.
//

import UIKit

class RunLogCell: UITableViewCell {

    @IBOutlet weak var runDurationLbl: UILabel!
    @IBOutlet weak var totalDIstanceLbl: UILabel!
    @IBOutlet weak var averagePaceLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    /* Function to configure the table view Cell */
    func configure(run: Run) {
        runDurationLbl.text = run.duration.formatTimeDurationToString() //we created the formatTimedurationToString override methog
        totalDIstanceLbl.text = "\run.distance.metersToMiles(places: 2)) mi"  //we created the metersToMiles extension
        averagePaceLbl.text = run.pace.formatTimeDurationToString()
        dateLbl.text = run.date.getDateString()
        
    }

}
