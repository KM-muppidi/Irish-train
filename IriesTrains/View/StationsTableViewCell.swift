//
//  StationsTableViewCell.swift
//  IriesTrains
//
//  Created by Kavya Muppidi Agrawal on 11/05/19.
//  Copyright © 2019 Kavya Muppidi Agrawal. All rights reserved.
//

import UIKit

class StationsTableViewCell: UITableViewCell {

    @IBOutlet weak var label0: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    
    @IBOutlet weak var desc0: UILabel!
    @IBOutlet weak var desc1: UILabel!
    @IBOutlet weak var desc2: UILabel!
    @IBOutlet weak var desc3: UILabel!
    @IBOutlet weak var desc4: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(stationDetails: StationDetails) {
        label0.text = "Station desc: "
        desc0.text = "\(stationDetails.StationDesc)"
        label1.text = "Station code: "
        desc1.text = "\(stationDetails.StationCode)"
        label2.text = "Station id: "
        desc2.text = "\(stationDetails.StationId)"
    }
    func configureCell(trainDetails: TrainDetails) {
        label0.text = "Train Status: "
        desc0.text = trainDetails.TrainStatus == "N" ? "Not Running" : "Running"
        label1.text = "Train Code: "
        desc1.text = "\(trainDetails.TrainCode)"
        label2.text = "Train Date: "
        desc2.text = "\(trainDetails.TrainDate)"
        label4.text = "Public Message: "
        let pubMsg = trainDetails.PublicMessage.replacingOccurrences(of: trainDetails.TrainCode, with: "").replacingOccurrences(of: "\\n", with: " ")
        desc4.text = "\(pubMsg)"
        label3.text = "Direction: "
        desc3.text = "\(trainDetails.Direction)"
    }
    
}
