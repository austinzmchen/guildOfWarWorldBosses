//
//  ACBorderedButton.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-20.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit

@IBDesignable
class ACBorderedButton: UIButton {
    
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
    
    // @IBInspectable UIEdgeInsets is not supported yet, so workaround like below
    @IBInspectable var textInsets: CGRect = CGRect() {
        didSet {
            let insets = UIEdgeInsets(top: textInsets.origin.x,
                                      left: textInsets.origin.y,
                                      bottom: textInsets.size.width,
                                      right: textInsets.size.height)
            self.contentEdgeInsets = insets
        }
    }
    
    var bgColor: UIColor? = nil
    @IBInspectable var hightlightBGColor: UIColor?
    
    override var isHighlighted: Bool {
        didSet {
            if let c = self.hightlightBGColor {
                if isHighlighted {
                    if self.bgColor == nil { // avoid being set to new hight light bg color
                        self.bgColor = self.backgroundColor
                    }
                    self.backgroundColor = c
                } else {
                    self.backgroundColor = bgColor
                }
            }
        }
    }
    
    // MARK: overrides
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.alpha = 1.0
            } else {
                self.alpha = 0.5
            }
        }
    }
}
