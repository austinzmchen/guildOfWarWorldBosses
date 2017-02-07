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
    func didTriggerToggleButton()
    func drawerItemVCShouldChange()
}

enum DrawerOpeningState {
    case closed
    case open
}

class WBDrawerMasterViewController: UINavigationController {
    
    fileprivate var selectedDrawerItem: WBDrawerItem?
    
    let drawerVC = WBStoryboardFactory.drawerStoryboard.instantiateViewController(withIdentifier: "drawerVC") as! WBDrawerViewController
    
    fileprivate var drawerOpeningState: DrawerOpeningState = .closed
    
    func setDrawerOpeningState(_ state: DrawerOpeningState, animated: Bool = true,
                               completion: ((_ stateChange: Bool) -> ())? = nil)
    {
        guard state != self.drawerOpeningState else {
            if let c = completion { c(false) }
            return
        }
        
        switch state {
        case .open:
            self.present(drawerVC, animated: false, completion: {
                if let c = completion { c(true) }
            }) // if using animated true, there will be a glitch where two phase, first phase fading in, second phase blurring
        case .closed:
            if animated {
                drawerVC.dismiss(animated: animated, completion: {
                    if let c = completion { c(true) }
                })
            } else {
                if let c = completion { c(true) }
            }
            break
        }
        self.drawerOpeningState = state
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
    }
    
    func presentAPIKeyEntryViewController() {
        let navVC = WBStoryboardFactory.apiKeyEntryStoryboard.instantiateInitialViewController() as! UINavigationController
        if let rootVC = navVC.viewControllers.first as? WBAPIKeyEntryViewController {
            rootVC.isShownFullscreen = false
            rootVC.viewDelegate = self
            self.viewControllers = [rootVC]
        }
    }
}

extension WBDrawerMasterViewController: WBDrawerViewControllerDelegate {
    
    func didSelect(drawerItem: WBDrawerItem, atIndex index: Int) {
        selectedDrawerItem = drawerItem
        
        // set drawer selected state
        // let drawerVC = (self.drawerViewController as! UINavigationController).viewControllers.first as! WBDrawerViewController
        drawerVC.selectedDrawerItem = self.selectedDrawerItem
        drawerVC.tableView?.reloadData()
        
        if !WBKeyStore.isAccountAvailable &&
            drawerItem.title != "Boss Timers"
        {
            self.presentAPIKeyEntryViewController()
        } else {
            self.presentDrawerItemViewController(drawerItem: drawerItem)
        }
        self.setDrawerOpeningState(.closed)
    }
}

extension WBDrawerMasterViewController: WBDrawerMasterViewControllerDelegate {
    
    func didTriggerToggleButton() {
        switch drawerOpeningState { // current state
        case .closed:
            self.setDrawerOpeningState(.open)
        case .open:
            if !WBKeyStore.isAccountAvailable {
                self.presentAPIKeyEntryViewController()
            }
            self.setDrawerOpeningState(.closed)
        }
    }
    
    func drawerItemVCShouldChange() {
        guard let drawerItem = selectedDrawerItem else {
            return
        }
        
        self.presentDrawerItemViewController(drawerItem: drawerItem)
    }
}
