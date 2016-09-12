//
//  WBMainTableViewCell.swift
//  TimerCountDown
//
//  Created by Austin Chen on 2016-08-14.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit

protocol WBMainTableViewCellDelegate: class {
    func selectFavorite(isSelected selected: Bool, forBoss boss: String)
}

class WBMainTableViewCell: UITableViewCell {

    @IBOutlet weak var bossImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var spawnTimeLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!

    weak var delegate: WBMainTableViewCellDelegate?
    
    func favButtonTapped(sender: AnyObject) {
        self.favButton.selected = !favButton.selected
        
        if let name = self.nameLabel.text {
            self.delegate?.selectFavorite(isSelected: favButton.selected, forBoss: name)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.favButton.setImage(UIImage(named: "unheartIcon"), forState: .Normal)
        self.favButton.setImage(UIImage(named: "heartIcon"), forState: .Selected)
        favButton.addTarget(self, action: #selector(favButtonTapped(_:)), forControlEvents: .TouchUpInside)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        self.favButton.selected = false
    }
}
