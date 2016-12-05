//
//  UIApplication+Loader.swift
//  GoW
//
//  Created by Austin Chen on 2016-09-14.
//  Copyright © 2016 10.1. All rights reserved.
//

import UIKit

/* UIWindow based loader view, good for loading overlaying on top of view controller transitions
 */

protocol UIApplicationLoaderView {
    static func showLoader()
    static func hideLoader()
}

extension UIApplication: UIApplicationLoaderView {
    static func showLoader() {
        // create if not exist
        WBLoaderViewController.sharedInstance = (WBLoaderViewController.sharedInstance ?? WBLoaderViewController.instantiate())
        // check & create alias
        guard let loaderVC = WBLoaderViewController.sharedInstance else {
            return
        }
        
        if loaderVC.view.superview != nil { // reset to initial state
            loaderVC.view.removeFromSuperview()
        }
        
        UIApplication.shared.keyWindow?.addSubview(loaderVC.view)
    }
    
    static func hideLoader() {
        guard let loaderVC = WBLoaderViewController.sharedInstance else {
            return
        }
        
        if loaderVC.view.superview != nil {
            loaderVC.view.removeFromSuperview()
            WBLoaderViewController.sharedInstance = nil // dealloc
        }
    }
}
