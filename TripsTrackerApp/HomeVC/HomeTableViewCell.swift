//
//  HomeTableViewCell.swift
//  TripsTrackerApp
//
//  Created by Hasan onur Can on 16.08.2022.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var tripNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
