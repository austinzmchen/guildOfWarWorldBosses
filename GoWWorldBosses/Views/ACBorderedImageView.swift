//
//  ACBorderedImageView.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2017-03-02.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

@IBDesignable
class ACBorderedImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var edgeInsets: CGRect = CGRect() {
        didSet {
            let insets = UIEdgeInsets(top: edgeInsets.origin.x,
                                      left: edgeInsets.origin.y,
                                      bottom: edgeInsets.size.width,
                                      right: edgeInsets.size.height)
            self.layoutMargins = insets
        }
    }
    
}
