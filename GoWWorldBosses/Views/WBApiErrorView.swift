//
//  WBApiErrorView.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-28.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit

class WBApiErrorView: UIView {

    @IBOutlet var contentView: UIView!
    
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
        let nib = UINib(nibName: "WBApiErrorView", bundle: bundle)
        contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        self.addSubview(contentView)
    }
}
