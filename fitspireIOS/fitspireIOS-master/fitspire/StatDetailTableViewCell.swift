//
//  StatDetailTableViewCell.swift
//  fitspire
//
//  Created by LUNVCA on 8/1/17.
//  Copyright © 2017 uca. All rights reserved.
//

import UIKit

class StatDetailTableViewCell: UITableViewCell {
    @IBOutlet var exerciseLabel : UILabel!
    @IBOutlet var repLabel : UILabel!
    @IBOutlet var weightLabel : UILabel!
    @IBOutlet var setCountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
