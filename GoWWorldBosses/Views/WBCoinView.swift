//
//  WBCoinView.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2017-03-04.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

@IBDesignable
class WBCoinView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var goldLabel: UILabel!
    @IBOutlet weak var goldDividerView: UIView!
    @IBOutlet weak var silverLabel: UILabel!
    @IBOutlet weak var silverDividerView: UIView!
    @IBOutlet weak var bronzeLabel: UILabel!
    
    // MARK: life cycles
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    func xibSetup() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "WBCoinView", bundle: bundle)
        contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        self.addSubview(contentView)
        
        contentView.frame = self.bounds
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: bronzeLabel.frame.maxX, height: self.goldDividerView.bounds.height)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: bronzeLabel.frame.maxX, height: self.goldDividerView.bounds.height)
    }
    
    // MARK: instance methods 
    
    var coinValue: Int {
        get {
            let gold = Int(goldLabel.text!)!
            let silver = Int(silverLabel.text!)!
            let bronze = Int(bronzeLabel.text!)!
            return gold * 10000 + silver * 100 + bronze
        }
        set { // hide gold or silver if 0
            let gold = newValue / 10000
            goldLabel.text = String(format: "%d", gold)
            if gold == 0 {
                var f = goldLabel.frame
                f.size = CGSize.zero
                goldLabel.frame = f
                goldLabel.invalidateIntrinsicContentSize()
                goldLabel.isHidden = true
                goldDividerView.isHidden = true
            } else {
                goldLabel.sizeToFit()
            }
            
            let silver = (newValue / 100) % 100
            silverLabel.text = String(format: "%d", silver)
            if silver == 0 {
                var f = silverLabel.frame
                f.size = CGSize.zero
                silverLabel.frame = f
                silverLabel.invalidateIntrinsicContentSize()
                silverLabel.isHidden = true
                silverDividerView.isHidden = true
            } else {
                silverLabel.sizeToFit()
            }
            
            bronzeLabel.text = String(format: "%d", newValue % 100)
            self.setNeedsLayout()
            self.invalidateIntrinsicContentSize()
        }
    }
}
