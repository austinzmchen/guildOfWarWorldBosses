//
//  AppDelegate+ForceTouchMenu.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2017-02-03.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

extension AppDelegate {
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void)
    {
        // declare steps
        let step_showTimerOrSettings = { (drawerMasterVC: WBDrawerMasterViewController, completion: () -> ()) in
            if shortcutItem.type == "kHomeScreenShortcutOpenTimers" {
                if let settingsPvc = drawerMasterVC.presentedViewController { // settings vc is presenteda
                    settingsPvc.dismiss(animated: false, completion: nil)
                }
                drawerMasterVC.didSelect(drawerItem: WBDrawerViewController.drawerItems[0], atIndex: 0)
                drawerMasterVC.setDrawerOpeningState(.closed, animated: false)
                
            } else if shortcutItem.type == "kHomeScreenShortcutOpenSettings" {
                if let settingsNavVC = drawerMasterVC.drawerVC.presentedViewController as? UINavigationController {
                    settingsNavVC.popToRootViewController(animated: false) // if settings VC already presented
                } else {
                    drawerMasterVC.setDrawerOpeningState(.open, animated: false, completion: { stateChange in
                        drawerMasterVC.drawerVC.showSettingsPage(animated: false)
                    })
                    
                }
            }
            completion()
        }
        
        /* proceed to execute
        */
        guard let rootVC = application.presentedViewControllers.first else { return }
        
        if let drawerMasterVC = rootVC.presentedViewController as? WBDrawerMasterViewController {
            // app already past initial api key entry page
            step_showTimerOrSettings(drawerMasterVC, {})
        } else { // app not past initial api key entry page
            if let rootNavVC = rootVC as? UINavigationController,
                let apiKeyEntryVC = rootNavVC.viewControllers.first as? WBAPIKeyEntryViewController
            {
                apiKeyEntryVC.presentLandingView(animated: false, completion: {}) // mimick tapping 'skip'
                
                guard let drawerMasterVC = apiKeyEntryVC.presentedViewController as? WBDrawerMasterViewController else {
                    return
                }
                step_showTimerOrSettings(drawerMasterVC, {})
            }
        }
    }
}
