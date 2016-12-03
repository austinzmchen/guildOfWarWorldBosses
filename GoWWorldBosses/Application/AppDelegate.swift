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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var syncCoordinator: WBSyncCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])

        // Override point for customization after application launch.
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.isStatusBarHidden = false
        
        // add local notification feature
        let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        
        
        
        
        
        
        syncCoordinator = WBSyncCoordinator(remoteSession: WBRemoteSession(domain: "https://api.guildwars2.com/v2", bearer: "51891488-0A13-EB45-9852-A98A08D45B092F3570C8-4F23-496B-A0F3-5E2B9FAF07B9"))
        syncCoordinator?.syncAll({ (success, error) in
            print("reach\(success)")
        })
        
        
        /*
        // test
        
        // Realms are used to group data together
        let realm = try! Realm() // Create realm pointing to default file
        
        // Link objects
        let bankItem = WBBankItem()
        bankItem.id = 20006
        bankItem.name = "Magic Find Booster"
        bankItem.descriptionText = "Double-click to gain an enhancement that gives an additional 50% Magic Find for one hour."
        bankItem.level = 0
        
        let bankItem1 = WBBankItem()
        bankItem1.id = 43485
        bankItem1.name = "WXP Mini-Booster"
        bankItem1.level = 0
        
        try! realm.write {
            realm.add(bankItem)
            realm.add(bankItem1)
        }
        
        // Query
        let results = realm.objects(WBBankItem.self).filter(NSPredicate(format: "name contains 'WX'"))
        
        // Queries are chainable!
        let results2 = results.filter("level >= 0")
        print("Number of bankItem: \(results.count)")
        print("bankItem level greater than 0: \(results2.count)")
        
        
        
        // Link objects
        let currency = WBCurrency()
        currency.id = 1
        currency.name = "Coin"
        currency.descriptionText = "The primary currency of Tyria. Spent at vendors throughout the world."
        
        try! realm.write {
            realm.add(currency)
        }

        // Query
        let newResults = realm.objects(WBCurrency.self).filter(NSPredicate(format: "name contains 'in'"))
        
        
        print("Number of currency: \(newResults.count)")
        
        */
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {}

}
