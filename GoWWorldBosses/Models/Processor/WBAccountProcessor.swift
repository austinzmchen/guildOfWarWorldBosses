//
//  WBAccountProcessor.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-14.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import RealmSwift

class WBAccountProcessor: NSObject {
    let context: WBSyncContext
    
    init (context: WBSyncContext) {
        self.context = context
    }
    
    lazy var accountRemote: WBAccountRemoteType = {
        return WBAccountRemote()
    }()
    
    func sync(completion: @escaping (_ success: Bool, _ syncedObjects: [AnyObject]?, _ error: NSError?) -> ()) {
        guard let apiKey = WBKeyStore.keyStoreItem?.accountAPIKey else {
            completion(false, nil, nil)
            return
        }
        
        self.accountRemote.fetchAccount(byApiKey: apiKey, completion: { (success, account) in
            guard success,
                let acc = account else
            {
                DispatchQueue.main.async {
                    completion(false, nil, nil)
                }
                return
            }
            
            let realm = try! Realm()
            let changes: [WBRemoteRecordChange<WBJsonAccount, WBAccount>] = realm.findOrInsert([acc])
            
            try! realm.write {
                for change in changes {
                    switch change {
                    case .found(let remoteRecord, let localObject):
                        localObject.saveSyncableProperties(fromSyncable: remoteRecord)
                        realm.add(localObject, update: true)
                        break
                    case .inserted(let remoteRecord, let localObject):
                        localObject.saveSyncableProperties(fromSyncable: remoteRecord)
                        realm.add(localObject)
                        break
                    default:
                        break
                    }
                }
            }
            DispatchQueue.main.async {
                completion(true, [acc], nil)
            }
        })
    }
}
