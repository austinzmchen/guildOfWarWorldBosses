//
//  WBMainViewController+NavigationBar.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-09-18.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit

extension WBMainViewController {
    
    func addBlurEffect() {
        // set navigation bar
        let bounds = self.navigationController?.navigationBar.bounds as CGRect!
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        visualEffectView.frame = bounds
        visualEffectView.frame.origin.y = -20.0
        visualEffectView.frame.size.height += 20.0
        visualEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.navigationController?.navigationBar.addSubview(visualEffectView)
        self.navigationController?.navigationBar.sendSubviewToBack(visualEffectView)
    }
    
    func setNavTitleView() {
        let titleImageView = UIImageView(image: UIImage(named: "dragon"))
        titleImageView.contentMode = .ScaleAspectFit
        var f = titleImageView.frame
        f.size = CGSize(width: 38.0, height: 38.0)
        titleImageView.frame = f
        self.navigationItem.titleView = titleImageView
    }
}