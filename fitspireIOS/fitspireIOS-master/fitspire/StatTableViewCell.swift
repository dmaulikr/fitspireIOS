//
//  StatTableViewCell.swift
//  fitspire
//
//  Created by LUNVCA on 8/1/17.
//  Copyright © 2017 uca. All rights reserved.
//

import UIKit

class StatTableViewCell: UITableViewCell {
    @IBOutlet var instanceLabel : UILabel!
    @IBOutlet var workoutLabel : UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
