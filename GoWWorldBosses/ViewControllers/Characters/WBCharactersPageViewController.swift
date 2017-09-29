//
//  WBCharactersPageViewController.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2017-09-29.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

class WBCharactersPageViewController: ACCustomPageViewController {
    required init?(coder aDecoder: NSCoder) { // this method is invoked before application:didFinishLaunchingWithOptions
        super.init(coder: aDecoder)
        
        let characterTableVC = WBStoryboardFactory.charactersStoryboard.instantiateViewController(withIdentifier: "charactersTableVC") as! WBCharactersTableViewController
        
        let vcs: [UIViewController] = [characterTableVC]
        
        cardViewControllers = vcs
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabsHeaderView?.tabTitles = ["Characters"]
        tabsHeaderView?.style = .centerTab
    }

}
