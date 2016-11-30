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

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.accodeworks.GoWWorldBosses" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "GoWWorldBosses", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}

