//
//  UIBarButtonPlus.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-20.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    static func barButtonItem(withImageName name: String, title: String? = nil, forTarget target: Any?, action: Selector) -> UIBarButtonItem {
        // set up image
        let img = UIImage(named: name)?.withRenderingMode(.alwaysOriginal) // the image has to be masked properly
        
        // set up button
        let leftButton = ACBarButton()
        leftButton.setImage(img, for: .normal)
        leftButton.addTarget(target, action: action, for: .touchUpInside)
        leftButton.tintColor = UIColor.black
        leftButton.setTitle(title, for: .normal)
        leftButton.titleLabel?.text = title
        leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: UIFontWeightBold)
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0)
        
        var f = leftButton.bounds
        f = CGRect(x: 0, y: 0, width: leftButton.intrinsicContentSize.width, height: img!.size.height)
        leftButton.bounds = f
        
        // for debug 
        //leftButton.backgroundColor = UIColor.gray
        
        // set up bar button
        return UIBarButtonItem(customView: leftButton)
    }
}

class ACBarButton: UIButton {
    
    override var alignmentRectInsets: UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
}
