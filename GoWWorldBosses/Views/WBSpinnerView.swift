//
//  WBSpinnerView.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2017-02-06.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

class WBSpinnerView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var spinnerImageView: UIImageView!

    var status: WBLoaderStatus = .loading
    
    // MARK: life cycles
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        loadNib()
    }
    
    deinit {
        self.status = .loaded
    }
    
    func loadNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "WBSpinnerView", bundle: bundle)
        contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        self.addSubview(contentView)
    }
    
    // MARK: life cycles
    
    override func awakeFromNib() {
        // add the missing contrainst between xib contentView to self
        let g = self.layoutMarginsGuide
        contentView.leadingAnchor.constraint(equalTo: g.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: g.trailingAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0).isActive = true
        contentView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1.0).isActive = true
        contentView.setNeedsUpdateConstraints()
        contentView.frame = self.bounds // set child view to match parent
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = self.bounds // set child view to match parent
    }
}

extension WBSpinnerView {
    
    @objc fileprivate func startLoader() {
        switch self.status {
        case .loading:
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveLinear, animations: { [weak self] in
                if let iv = self?.spinnerImageView {
                    iv.transform = iv.transform.rotated(by: -CGFloat(M_PI_2))
                }
            }) { [weak self] (finished) -> () in
                _ = self?.perform(#selector(self?.startLoader))
            }
            break
        default:
            break
        }
    }
    
    func resetLoader() {
        self.status = .loading
        self.startLoader()
    }
}
