//
//  TrackCell.swift
//  DevelopingiOSAppsUsingSwiftTutorial-Part1
//
//  Created by Viatori on 15/09/2017.
//  Copyright © 2017 Jameson Quave. All rights reserved.
//

import UIKit

class TrackCell: UITableViewCell {
    @IBOutlet weak var playIcon: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
