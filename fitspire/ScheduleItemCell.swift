//
//  WorkoutItemCell.swift
//  fitspire
//
//  Created by LUNVCA on 1/24/17.
//  Copyright © 2017 uca. All rights reserved.
//

import UIKit

class ScheduleItemCell: UITableViewCell {

    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var Day: UILabel!
    @IBOutlet weak var Pic: UIImageView!
    
    var SplitItem: SplitItem?{
        didSet {
            if let item = SplitItem {
                Day.text = item.day
               Pic.image = item.image
                Description.text = item.summary
            }
            else {
                Day.text = nil
                Description.text = nil
            }
    }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
