//
//  UIApplication.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2017-02-03.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

extension UIApplication {
    
    var presentedViewControllers: [UIViewController] {
        var vcs: [UIViewController] = []
        
        var vc: UIViewController? = self.keyWindow?.rootViewController
        while vc != nil {
            vcs.append(vc!)
            vc = vc!.presentedViewController
        }
        return vcs
    }
}
