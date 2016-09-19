//
//  WBKeyStore.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-09-18.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import Locksmith

/* using both NSUserDefaults and Keychain for user session life cycle + security
 */
let kUserDefaultKey = "kGoWUserDefaultKey" // Pro: removed when app uninstalls, prefect for the case checking whether user should be auto signed in, Con: plain text

let kKeychainItemKey = "kGoWKeychainItemKey" // Pro: secure.

struct WBKeyStoreItem {
    var likedBosses: Set<String> = Set<String>()
}

class WBKeyStore: NSObject {
    static let kLocksmithUserAccountName = "kGoWUserAccountName" // Pro: secure.
    
    static var keyStoreItem: WBKeyStoreItem? {
        get {
            guard let _ = NSUserDefaults.standardUserDefaults().objectForKey(kUserDefaultKey) else {
                return nil // app is either never installed, or deleted
            }
            if let dict = Locksmith.loadDataForUserAccount(kLocksmithUserAccountName) {
                if let bosses = dict["likedBosses"] as? Set<String> {
                    return WBKeyStoreItem(likedBosses: bosses)
                } else {
                    return nil
                }
            } else {
                print("Error: HAPKeyStore - item is registered in NSUserDefaults, but not present in Keychain")
                return nil
            }
        }
        set {
            if let item = newValue {
                let dict = ["likedBosses": item.likedBosses as NSSet]
                do {
                    if let _ = Locksmith.loadDataForUserAccount(kLocksmithUserAccountName) {
                        try Locksmith.updateData(dict, forUserAccount: kLocksmithUserAccountName)
                    } else {
                        try Locksmith.saveData(dict, forUserAccount: kLocksmithUserAccountName)
                    }
                } catch let error as NSError {
                    print("Error: HAPKeyStore - %@", error)
                }
                NSUserDefaults.standardUserDefaults().setObject(NSNumber(bool: true), forKey: kUserDefaultKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            } else {
                do {
                    try Locksmith.deleteDataForUserAccount(kLocksmithUserAccountName)
                } catch let error as NSError {
                    print("Error: HAPKeyStore - %@", error)
                }
                NSUserDefaults.standardUserDefaults().removeObjectForKey(kUserDefaultKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }
}
