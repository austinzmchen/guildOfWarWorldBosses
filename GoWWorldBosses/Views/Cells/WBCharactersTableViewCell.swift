//
//  WBCharactersTableViewCell.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-13.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit

class WBCharactersTableViewCell: UITableViewCell {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
