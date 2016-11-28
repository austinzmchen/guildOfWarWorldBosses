//
//  WBDrawerMasterViewController.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-27.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit
import KYDrawerController

class WBDrawerMasterViewController: KYDrawerController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let drawerNavVC = WBStoryboardFactory.drawerStoryboard.instantiateViewController(withIdentifier: "drawerNavVC") as! UINavigationController
        let drawerRootVC = drawerNavVC.viewControllers.first as! WBDrawerViewController
        drawerRootVC.delegate = self
        
        self.drawerViewController = drawerNavVC
        self.drawerViewController?.view.setNeedsLayout() // hack - to preload table items
        self.drawerWidth = UIScreen.main.bounds.width
    }
}

extension WBDrawerMasterViewController: WBDrawerViewControllerDelegate {
    func didSelect(drawerItem: WBDrawerItem, atIndex index: Int) {
        let vc = WBStoryboardFactory.storageStoryboard.instantiateViewController(withIdentifier: "storageNavVC")
        self.mainViewController = vc
        self.setDrawerState(.closed, animated: true)
    }
}
