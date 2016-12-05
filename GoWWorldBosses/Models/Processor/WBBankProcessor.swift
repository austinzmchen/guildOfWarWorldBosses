//
//  WBBankProcessor.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-30.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import RealmSwift

class WBBankProcessor: NSObject {
    let context: WBSyncContext
    
    init (context: WBSyncContext) {
        self.context = context
    }
    
    lazy var bankRemote: WBBankRemoteType = {
        return WBBankRemote(remoteSession: self.context.remoteSession)
    }()
    
    func sync(completion: @escaping (_ success: Bool, _ syncedObjects: [AnyObject]?, _ error: NSError?) -> ()) {
        self.bankRemote.fetchBanks { (success, bankIds) in
            guard let ids = bankIds else {
                completion(false, nil, nil)
                return
            }
            
//            let ids = banks.map{ $0.id }
            self.bankRemote.fetchBankItems(byIds: ids, completion: { (success, bankItems) in
                guard success,
                    let items = bankItems else
                {
                    completion(false, nil, nil)
                    return
                }
                
                let realm = try! Realm()
                let changes: [WBRemoteRecordChange<WBJsonBankItem, WBBankItem>] = realm.findOrInsert(items)
                
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
            
                completion(true, items as [AnyObject]?, nil)
            })
        }
    }
}
