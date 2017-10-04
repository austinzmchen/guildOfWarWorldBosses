//
//  WBTimerPageMainViewController.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2017-09-22.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit
import RZTransitions

class WBTimerPageMainViewController: ACCustomPageViewController {
    
    required init?(coder aDecoder: NSCoder) { // this method is invoked before application:didFinishLaunchingWithOptions
        super.init(coder: aDecoder)
        
        let vc1 = WBStoryboardFactory.timerStoryboard.instantiateViewController(withIdentifier: "timerVC") as! WBTimerViewController
//        vc1.view.backgroundColor = UIColor.green
        
        let vc2 = UIViewController()
//        vc2.view.backgroundColor = UIColor.yellow
        
        let vcs:[UIViewController] = [vc1, vc2]
        
        cardViewControllers = vcs
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabsHeaderView?.tabTitles = ["Boss Timers", "Achievements"]
        tabsHeaderView?.style = .centerTab
    }
}
