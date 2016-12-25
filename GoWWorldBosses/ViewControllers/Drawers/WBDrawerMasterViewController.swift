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

fileprivate enum DrawerOpeningState {
    case closed
    case open
}

class WBDrawerMasterViewController: UINavigationController {
    
    fileprivate var selectedDrawerItem: WBDrawerItem?
    
    let drawerVC = WBStoryboardFactory.drawerStoryboard.instantiateViewController(withIdentifier: "drawerVC") as! WBDrawerViewController
    
    fileprivate var drawerOpeningState: DrawerOpeningState = .closed {
        didSet {
            switch drawerOpeningState {
            case .open:
                self.present(drawerVC, animated: false, completion: nil) // if using animated true, there will be a glitch where two phase, first phase fading in, second phase blurring 
                break
            case .closed:
                drawerVC.dismiss(animated: true, completion: nil)
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        drawerVC.delegate = self
        drawerVC.viewDelegate = self
        
        // set up main
        let timerNavVC = WBStoryboardFactory.timerStoryboard.instantiateViewController(withIdentifier: "timerNavVC") as! UINavigationController
        let timerVC = timerNavVC.viewControllers.first as! WBMainViewController
        timerVC.viewDelegate = self
        
        self.viewControllers = [timerVC]
    }
    
    func presentDrawerItemViewController(drawerItem: WBDrawerItem) {
        let vc = WBStoryboardFactory.storyboard(byFileName: drawerItem.storyboardFileName)?.instantiateViewController(withIdentifier: drawerItem.storyboardID)
      
        if let navVC = vc as? UINavigationController,
            let rootVC = navVC.viewControllers.first,
            let drawerItemVC = rootVC as? WBDrawerItemViewControllerType
        {
            drawerItemVC.viewDelegate = self
            self.viewControllers = [rootVC]
        }
        
        self.drawerOpeningState = .closed
    }
}

extension WBDrawerMasterViewController: WBDrawerViewControllerDelegate {
    
    func didSelect(drawerItem: WBDrawerItem, atIndex index: Int) {
        selectedDrawerItem = drawerItem
        
        // set drawer selected state
        // let drawerVC = (self.drawerViewController as! UINavigationController).viewControllers.first as! WBDrawerViewController
        drawerVC.selectedDrawerItem = self.selectedDrawerItem
        drawerVC.tableView.reloadData()
        
        if WBKeyStore.keyStoreItem?.accountAPIKey == "" &&
            drawerItem.title != "Boss Timers"
        {
            let navVC = WBStoryboardFactory.apiKeyEntryStoryboard.instantiateInitialViewController() as! UINavigationController
            if let rootVC = navVC.viewControllers.first as? WBAPIKeyEntryViewController {
                rootVC.isShownFullscreen = false
                rootVC.viewDelegate = self
                self.viewControllers = [rootVC]
                self.drawerOpeningState = .closed
            }
            return
        }
        
        self.presentDrawerItemViewController(drawerItem: drawerItem)
    }
}

extension WBDrawerMasterViewController: WBDrawerMasterViewControllerDelegate {
    
    func toggleDrawerView() {
        switch drawerOpeningState {
        case .closed:
            self.drawerOpeningState = .open
            break
        case .open:
            self.drawerOpeningState = .closed
            break
        }
    }
    
    func drawerItemVCShouldChange() {
        guard let drawerItem = selectedDrawerItem else {
            return
        }
        
        self.presentDrawerItemViewController(drawerItem: drawerItem)
    }
}
