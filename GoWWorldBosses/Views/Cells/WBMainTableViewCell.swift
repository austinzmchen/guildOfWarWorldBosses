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

enum WBTableCellCountDownStyle {
    case active
    case countDown(countDown: Int)
    case countDownRed(countDown: Int)
}

func ==(lhs: WBTableCellCountDownStyle, rhs: WBTableCellCountDownStyle) -> Bool {
    switch (lhs,rhs) {
    case (.active, .active): return true
    default: return false
    }
}

class WBMainTableViewCell: UITableViewCell {

    @IBOutlet weak var bossImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var locationCodeLabel: UILabel!
    @IBOutlet weak var spawnTimeLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var favAnimImageView: UIImageView!

    var boss: WBBoss?
    weak var delegate: WBMainTableViewCellDelegate?
    
    func favButtonTapped(_ sender: AnyObject) {
        if !self.favButton.isSelected {
            self.favAnimImageView.alpha = 0
            UIView.animate(withDuration: 0.22, delay: 0, options: .curveEaseOut, animations: {
                self.favAnimImageView.transform = CGAffineTransform(scaleX: 20, y: 20)
                self.favAnimImageView.alpha = 1
            }) { (completed) in
                self.favButton.isSelected = !self.favButton.isSelected
                self.favAnimImageView.alpha = 0
                self.favAnimImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                
                if let b = self.boss {
                    self.delegate?.selectFavorite(isSelected: self.favButton.isSelected, forBoss: b)
                }
            }
        } else {
            self.favButton.isSelected = !self.favButton.isSelected
            if let b = self.boss {
                self.delegate?.selectFavorite(isSelected: self.favButton.isSelected, forBoss: b)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.favButton.setImage(UIImage(named: "unheartIcon"), for: UIControlState())
        self.favButton.setImage(UIImage(named: "heartIcon"), for: .selected)
        favButton.addTarget(self, action: #selector(favButtonTapped(_:)), for: .touchUpInside)
        self.favAnimImageView.alpha = 0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var countDownStyle: WBTableCellCountDownStyle = .countDown(countDown: 0) {
        didSet {
            switch countDownStyle {
                case .active:
                    self.countDownLabel.textColor = UIColor(red: 117/255.0, green: 214/255.0, blue: 17/255.0, alpha: 1)
                    self.countDownLabel.text = "LIVE"
                    break
                case .countDownRed(let countDown):
                    self.countDownLabel.textColor = UIColor.red
                    self.countDownLabel.text = countDown.nextSpawnTimeCountDownStringFromDate()
                    break
                case .countDown(let countDown):
                    self.countDownLabel.textColor = UIColor.white
                    self.countDownLabel.text = countDown.nextSpawnTimeCountDownStringFromDate()
                    break
            }
        }
    }
    
    override func prepareForReuse() {
        self.favButton.isSelected = false
        self.favAnimImageView.alpha = 0
    }
}
