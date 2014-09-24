//
//  ToggleTableViewCell.swift
//  yelp
//
//  Created by Dan Schultz on 9/20/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import UIKit

class ToggleTableViewCell: UITableViewCell {

    @IBOutlet weak var toggleSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
