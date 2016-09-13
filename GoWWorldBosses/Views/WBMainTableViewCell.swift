//
//  WBMainTableViewCell.swift
//  TimerCountDown
//
//  Created by Austin Chen on 2016-08-14.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit

protocol WBMainTableViewCellDelegate: class {
    func selectFavorite(isSelected selected: Bool, forBoss boss: WBBoss)
}

class WBMainTableViewCell: UITableViewCell {

    @IBOutlet weak var bossImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var spawnTimeLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var favAnimImageView: UIImageView!

    var boss: WBBoss?
    weak var delegate: WBMainTableViewCellDelegate?
    
    func favButtonTapped(sender: AnyObject) {
        if !self.favButton.selected {
            self.favAnimImageView.alpha = 0
            UIView.animateWithDuration(0.22, delay: 0, options: .CurveEaseOut, animations: {
                self.favAnimImageView.transform = CGAffineTransformMakeScale(12.5, 11.25)
                self.favAnimImageView.alpha = 1
            }) { (completed) in
                self.favButton.selected = !self.favButton.selected
                self.favAnimImageView.alpha = 0
                self.favAnimImageView.transform = CGAffineTransformMakeScale(1, 1)
                
                if let b = self.boss {
                    self.delegate?.selectFavorite(isSelected: self.favButton.selected, forBoss: b)
                }
            }
        } else {
            self.favButton.selected = !self.favButton.selected
            if let b = self.boss {
                self.delegate?.selectFavorite(isSelected: self.favButton.selected, forBoss: b)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.favButton.setImage(UIImage(named: "unheartIcon"), forState: .Normal)
        self.favButton.setImage(UIImage(named: "heartIcon"), forState: .Selected)
        favButton.addTarget(self, action: #selector(favButtonTapped(_:)), forControlEvents: .TouchUpInside)
        self.favAnimImageView.alpha = 0
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        self.favButton.selected = false
        self.favAnimImageView.alpha = 0
    }
}
