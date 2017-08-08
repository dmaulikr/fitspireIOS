//
//  WorkoutTableViewCell.swift
//  fitspire
//
//  Created by LUNVCA on 7/20/17.
//  Copyright © 2017 uca. All rights reserved.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {

    @IBOutlet var workoutLabel : UILabel!
    @IBOutlet var workoutPic : UIImageView!
    @IBOutlet weak var actionButton: UIButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
