//
//  WBDrawerMasterViewController.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-27.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit
import KYDrawerController

protocol WBDrawerItemViewControllerType: class {
    var viewDelegate: WBDrawerMasterViewControllerDelegate? {get set}
}

protocol WBDrawerMasterViewControllerDelegate: class {
    func toggleDrawerView()
    func drawerItemVCShouldChange()
}

class WBDrawerMasterViewController: KYDrawerController {
    
    fileprivate var selectedDrawerItem: WBDrawerItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // set up drawer
        let drawerNavVC = WBStoryboardFactory.drawerStoryboard.instantiateViewController(withIdentifier: "drawerNavVC") as! UINavigationController
        let drawerRootVC = drawerNavVC.viewControllers.first as! WBDrawerViewController
        drawerRootVC.delegate = self
        drawerRootVC.viewDelegate = self
        
        self.drawerViewController = drawerNavVC
        self.drawerViewController?.view.setNeedsLayout() // hack - to preload table items
        self.drawerWidth = UIScreen.main.bounds.width
        
        // set up main
        let timerNavVC = WBStoryboardFactory.timerStoryboard.instantiateViewController(withIdentifier: "timerNavVC") as! UINavigationController
        let timerVC = timerNavVC.viewControllers.first as! WBMainViewController
        timerVC.viewDelegate = self
        
        self.mainViewController = timerNavVC
    }
}

extension WBDrawerMasterViewController: WBDrawerViewControllerDelegate {
    
    func didSelect(drawerItem: WBDrawerItem, atIndex index: Int) {
        selectedDrawerItem = drawerItem
        
        if WBKeyStore.keyStoreItem?.accountAPIKey == nil &&
            drawerItem.title != "Boss Timers"
        {
            let navVC = WBStoryboardFactory.apiKeyEntryStoryboard.instantiateInitialViewController() as! UINavigationController
            if let rootVC = navVC.viewControllers.first as? WBAPIKeyEntryViewController {
                rootVC.isShownFullscreen = false
                rootVC.viewDelegate = self
                self.mainViewController = navVC
                self.setDrawerState(.closed, animated: true)
            }
            return
        }
        
        let vc = WBStoryboardFactory.storyboard(byFileName: drawerItem.storyboardFileName)?.instantiateViewController(withIdentifier: drawerItem.storyboardID)
        
        if let navVC = vc as? UINavigationController,
            let rootVC = navVC.viewControllers.first,
            let drawerItemVC = rootVC as? WBDrawerItemViewControllerType
        {
            drawerItemVC.viewDelegate = self
            self.mainViewController = navVC
        }
        
        self.setDrawerState(.closed, animated: true)
    }
}

extension WBDrawerMasterViewController: WBDrawerMasterViewControllerDelegate {
    func toggleDrawerView() {
        var state = DrawerState.opened
        switch self.drawerState {
        case .opened:
            state = .closed
        case .closed:
            state = .opened
        }
        self.setDrawerState(state, animated: true)
    }
    
    func drawerItemVCShouldChange() {
        guard let drawerItem = selectedDrawerItem else {
            return
        }
        
        let vc = WBStoryboardFactory.storyboard(byFileName: drawerItem.storyboardFileName)?.instantiateViewController(withIdentifier: drawerItem.storyboardID)
        
        if let navVC = vc as? UINavigationController,
            let rootVC = navVC.viewControllers.first,
            let drawerItemVC = rootVC as? WBDrawerItemViewControllerType
        {
            drawerItemVC.viewDelegate = self
            self.mainViewController = navVC
        }
    }
}
