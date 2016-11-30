//
//  WBWalletProcessor.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-29.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import RealmSwift

class WBWalletProcessor: NSObject {
    let context: WBSyncContext
    
    init (context: WBSyncContext) {
        self.context = context
    }
    
    lazy var walletRemote: WBWalletRemoteType = {
        return WBWalletRemote(remoteSession: self.context.remoteSession)
    }()
    
    func sync(completion: @escaping (_ success: Bool, _ syncedObjects: [AnyObject]?, _ error: NSError?) -> ()) {
        self.walletRemote.fetchWalletItems { (success, walletItems) in
            guard let wis = walletItems else {
                completion(false, nil, nil)
                return
            }
            
            let ids = wis.map{ $0.id }
            self.walletRemote.fetchCurrencies(byIds: ids, completion: { (success, currencies) in
                guard success,
                    let currencies = currencies else
                {
                    completion(false, nil, nil)
                    return
                }
                
                let realm = try! Realm()
                let changes: [WBRemoteRecordChange<WBJsonCurrency, WBCurrency>] = realm.findOrInsert(currencies)
                
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
                
                completion(true, currencies as [AnyObject]?, nil)
            })
        }
    }
}
