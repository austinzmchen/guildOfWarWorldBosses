//
//  WBCharactersTableViewCell.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-13.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit

class WBCharactersTableViewCell: UITableViewCell {

    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
