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

enum DrawerOpeningState {
    case closed
    case open
}

class WBDrawerMasterViewController: UINavigationController {
    
    fileprivate var selectedDrawerItem: WBDrawerItem?
    
    let drawerVC = WBStoryboardFactory.drawerStoryboard.instantiateViewController(withIdentifier: "drawerVC") as! WBDrawerViewController
    
    var drawerOpeningState: DrawerOpeningState = .closed {
        didSet {
            guard drawerOpeningState != oldValue else {
                return
            }
            self.setDrawerOpeningState(drawerOpeningState, animted: true, completion: {})
        }
    }
    
    func setDrawerOpeningState(_ state: DrawerOpeningState, animted: Bool, completion: @escaping () -> ()) {
        switch state {
        case .open:
            self.present(drawerVC, animated: false, completion: {}) // if using animated true, there will be a glitch where two phase, first phase fading in, second phase blurring
            completion()
        case .closed:
            if animted {
                drawerVC.dismiss(animated: animted, completion: {
                    completion()
                })
            } else {
                completion()
            }
            break
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appIconForcePressed(_:)), name: Notification.Name("kAppIconForcePressed"), object: nil)

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
        
        if (WBKeyStore.keyStoreItem == nil ||
            WBKeyStore.keyStoreItem?.accountAPIKey == "") &&
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

// application shortcut items
extension WBDrawerMasterViewController {
    func appIconForcePressed(_ note: Notification) {
        if let shortcutItem = note.userInfo?["kShortCutItem"] as? UIApplicationShortcutItem {
            
            if shortcutItem.type == "kHomeScreenShortcutOpenTimers" {
                if let pvc = self.presentedViewController {
                    pvc.dismiss(animated: false, completion: nil) // dismiss settings vc
                    self.didSelect(drawerItem: WBDrawerViewController.drawerItems[0], atIndex: 0)
                    self.setDrawerOpeningState(.closed, animted: false, completion: {})
                }
            } else if shortcutItem.type == "kHomeScreenShortcutOpenSettings" {
                let completion = {
                    if let settingsNavVC = self.drawerVC.presentedViewController as? UINavigationController {
                        settingsNavVC.popToRootViewController(animated: false)
                    } else {
                        self.drawerVC.showSettingsPage(animated: false)
                    }
                }
                
                if self.drawerOpeningState == .closed {
                    self.setDrawerOpeningState(.open, animted: false, completion: {
                        completion()
                    })
                } else {
                    completion()
                }
            }
        }
    }
}
