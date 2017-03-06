//
//  AppDelegate.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-08-20.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

import CoreData
import RealmSwift

let appDelegate = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appConfiguration = AppConfiguration()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        Fabric.with([Crashlytics.self])
        
        // Override point for customization after application launch.
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.isStatusBarHidden = false
        
        // add local notification feature
        let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        
        // if app is deleted, remvoe all notification
        if UserDefaults.standard.object(forKey: kUserDefaultKey) == nil {
            UIApplication.shared.cancelAllLocalNotifications()
        }
        
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 3,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                migration.enumerateObjects(ofType: WBItem.className()) { oldObject, newObject in
                    // Add the `fullName` property only to Realms with a schema version of 0
                    if oldSchemaVersion < 3 {
                        newObject!["flags"] = nil
                        newObject!["rarity"] = nil
                        newObject!["vendorValue"] = nil
                    }
                }
            }
        )
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        let syncCoordinator = appDelegate.appConfiguration["syncCoordinator"] as? WBSyncCoordinator
        syncCoordinator?.syncAll({ (true, error) in
        })
    }

    func applicationWillTerminate(_ application: UIApplication) {}
}
