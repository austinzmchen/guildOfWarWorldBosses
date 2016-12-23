//
//  WBStorageWalletCoinTableViewCell.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-23.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit

class WBStorageWalletCoinTableViewCell: WBStorageItemTableViewCell {

    @IBOutlet weak var goldLabel: UILabel!
    @IBOutlet weak var silverLabel: UILabel!
    @IBOutlet weak var bronzeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
