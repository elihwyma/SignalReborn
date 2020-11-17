//
//  InfoCell.swift
//  SignalReborn
//
//  Created by Amy While on 23/09/2020.
//  Copyright © 2020 Amy While. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var specificLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup() {
        descriptionLabel.adjustsFontSizeToFitWidth = true
        specificLabel.adjustsFontSizeToFitWidth = true
    }
}
