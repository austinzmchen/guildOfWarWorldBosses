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

struct WBKeyStoreItem {
    var likedBosses: Set<String> = Set<String>()
    var accountAPIKey: String = ""
}

class WBKeyStore: NSObject {
    static let kLocksmithUserAccountName = "kGoWUserAccountName" // Pro: secure.
    
    static var keyStoreItem: WBKeyStoreItem? {
        get {
            guard let _ = UserDefaults.standard.object(forKey: kUserDefaultKey) else {
                return nil // app is either never installed, or deleted
            }
            if let dict = Locksmith.loadDataForUserAccount(userAccount: kLocksmithUserAccountName) {
                if let bosses = dict["likedBosses"] as? Set<String>,
                    let apiKey = dict["apiKey"] as? String {
                    return WBKeyStoreItem(likedBosses: bosses, accountAPIKey: apiKey)
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
                let dict: [String : Any] = ["likedBosses": item.likedBosses as NSSet,
                            "apiKey": item.accountAPIKey]
                do {
                    if let _ = Locksmith.loadDataForUserAccount(userAccount: kLocksmithUserAccountName) {
                        try Locksmith.updateData(data: dict, forUserAccount: kLocksmithUserAccountName)
                    } else {
                        try Locksmith.saveData(data: dict, forUserAccount: kLocksmithUserAccountName)
                    }
                } catch let error as NSError {
                    print("Error: HAPKeyStore - %@", error)
                }
                UserDefaults.standard.set(NSNumber(value: true as Bool), forKey: kUserDefaultKey)
                UserDefaults.standard.synchronize()
            } else {
                do {
                    try Locksmith.deleteDataForUserAccount(userAccount: kLocksmithUserAccountName)
                } catch let error as NSError {
                    print("Error: HAPKeyStore - %@", error)
                }
                UserDefaults.standard.removeObject(forKey: kUserDefaultKey)
                UserDefaults.standard.synchronize()
            }
        }
    }
}

extension WBKeyStore {
    static var isAccountAvailable: Bool { // by APIKey
        if WBKeyStore.keyStoreItem == nil ||
            WBKeyStore.keyStoreItem?.accountAPIKey == ""
        {
            return false
        } else {
            return true
        }
    }
}
