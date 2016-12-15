//
//  WBAPIKeyTableViewCell.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-14.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit

class WBAPIKeyTableViewCell: UITableViewCell {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
