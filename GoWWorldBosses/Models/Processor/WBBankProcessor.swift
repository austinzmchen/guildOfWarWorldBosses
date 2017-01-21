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
    
    lazy var itemRemote: WBItemRemote = {
        return WBItemRemote(remoteSession: self.context.remoteSession)
    }()
    
    func sync(completion: @escaping (_ success: Bool, _ syncedObjects: [AnyObject]?, _ error: Error?) -> ()) {
        self.syncBankElements { (success, elements, error) in
            guard success,
                let elements = elements else
            {
                completion(false, nil, nil)
                return
            }
            
            let ids = elements.map{ $0.id }
            self.syncBankItems(byIds: ids, completion: { (success, syncedObjects, error) in
                completion(success, syncedObjects, error)
            })
        }
    }
    
    func syncBankElements(completion: @escaping (_ success: Bool, _ elements: [WBJsonBankElement]?, _ error: Error?) -> ()) {
        self.bankRemote.fetchBanks { result in
            
            switch result {
            case .success(let bankElements):
                guard let elements = bankElements else {
                    DispatchQueue.main.async {
                        completion(false, nil, nil)
                    }
                    return
                }
                
                let realm = try! Realm()
                let changes: [WBRemoteRecordChange<WBJsonBankElement, WBBankElement>] = realm.findOrInsert(elements)
                
                do {
                    try realm.write {
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
                } catch {
                    print("Error info: \(error)")
                }
                DispatchQueue.main.async {
                    completion(true, bankElements, nil)
                }
                break
                
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(false, nil, error)
                }
                break
            }
        }
    }
    
    func syncBankItems(byIds ids:[String], completion: @escaping (_ success: Bool, _ elements: [WBJsonItem]?, _ error: Error?) -> ())
    {
        self.itemRemote.fetchItems(byIds: ids, completion: { result in
            switch result {
            case .success(let items):
                guard let items = items else
                {
                    DispatchQueue.main.async {
                        completion(false, nil, nil)
                    }
                    return
                }
                
                let realm = try! Realm()
                let changes: [WBRemoteRecordChange<WBJsonItem, WBItem>] = realm.findOrInsert(items)
                
                try! realm.write {
                    for change in changes {
                        switch change {
                        case .found(let remoteRecord, let localObject):
                            localObject.saveSyncableProperties(fromSyncable: remoteRecord)
                            realm.add(localObject, update: true)
                            
                            localObject.addToOneRelationship(WBBankElement.self, inverseRelationshipName: "item", foreignKey: localObject.id, realm: realm)
                            break
                        case .inserted(let remoteRecord, let localObject):
                            localObject.saveSyncableProperties(fromSyncable: remoteRecord)
                            realm.add(localObject)
                            
                            localObject.addToOneRelationship(WBBankElement.self, inverseRelationshipName: "item", foreignKey: localObject.id, realm: realm)
                            break
                        default:
                            break
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    completion(true, items, nil)
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
