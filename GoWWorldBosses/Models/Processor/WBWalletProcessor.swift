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
    
    func sync(completion: @escaping (_ success: Bool, _ syncedObjects: [AnyObject]?, _ error: Error?) -> ()) {
        self.syncWalletElements { (success, elements, error) in
            guard success,
                let elements = elements else
            {
                completion(false, nil, nil)
                return
            }
            
            let ids = elements.map{ $0.id }
            self.syncCurrencies(byIds: ids, completion: { (success, syncedObjects, error) in
                completion(success, syncedObjects, error)
            })
        }
    }
    
    func syncWalletElements(completion: @escaping (_ success: Bool, _ elements: [WBJsonWalletElement]?, _ error: Error?) -> ()) {
        self.walletRemote.fetchWalletElements { result in
            switch result {
            case .success(let walletElements):
                guard let we = walletElements else {
                    DispatchQueue.main.async {
                        completion(false, nil, nil)
                    }
                    return
                }
                
                let realm = try! Realm()
                let changes: [WBRemoteRecordChange<WBJsonWalletElement, WBWalletElement>] = realm.findOrInsert(we)
                
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
                    completion(true, walletElements, nil)
                }
                break
                
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(false, nil, error)
                }
            }
        }
    }
    
    func syncCurrencies(byIds ids: [String], completion: @escaping (_ success: Bool, _ syncedObjects: [WBJsonCurrency]?, _ error: Error?) -> ())
    {
        self.walletRemote.fetchCurrencies(byIds: ids, completion: { result in
            switch result {
            case .success(let currencies):
                guard let currencies = currencies else
                {
                    DispatchQueue.main.async {
                        completion(false, nil, nil)
                    }
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
                            
                            localObject.addToOneRelationship(WBWalletElement.self, relationshipName: "walletElement", inverseRelationshipName: "currency", foreignKey: localObject.id, realm: realm)
                            break
                        case .inserted(let remoteRecord, let localObject):
                            localObject.saveSyncableProperties(fromSyncable: remoteRecord)
                            realm.add(localObject)
                            
                            localObject.addToOneRelationship(WBWalletElement.self, relationshipName: "walletElement", inverseRelationshipName: "currency", foreignKey: localObject.id, realm: realm)
                            break
                        default:
                            break
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    completion(true, currencies, nil)
                }
                break
                
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(false, nil, error)
                }
                break
            }
        })
    }
}
