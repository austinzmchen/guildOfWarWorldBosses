//
//  WBMaterialProcessor.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-11.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import RealmSwift


class WBMaterialProcessor: NSObject {
    let context: WBSyncContext
    
    init (context: WBSyncContext) {
        self.context = context
    }
    
    lazy var materialRemote: WBMaterialRemoteType = {
        return WBMaterialRemote(remoteSession: self.context.remoteSession)
    }()
    
    lazy var itemRemote: WBItemRemote = {
        return WBItemRemote(remoteSession: self.context.remoteSession)
    }()
    
    func sync(completion: @escaping (_ success: Bool, _ syncedObjects: [AnyObject]?, _ error: NSError?) -> ()) {
        self.syncMaterialElements { (success, elements, error) in
            guard success,
                let elements = elements else
            {
                completion(false, nil, nil)
                return
            }
            
            let ids = elements.map{ $0.id }
            self.syncMaterialItems(byIds: ids, completion: { (success, syncedObjects, error) in
                completion(success, syncedObjects, nil)
            })
        }
    }
    
    func syncMaterialElements(completion: @escaping (_ success: Bool, _ elements: [WBJsonMaterialElement]?, _ error: NSError?) -> ()) {
        self.materialRemote.fetchMaterialElements { (success, elements) in
            guard let elements = elements else {
                completion(false, nil, nil)
                return
            }
            
            let realm = try! Realm()
            let changes: [WBRemoteRecordChange<WBJsonMaterialElement, WBMaterialElement>] = realm.findOrInsert(elements)
            
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
            completion(true, elements, nil)
        }
    }
    
    func syncMaterialItems(byIds ids:[Int64], completion: @escaping (_ success: Bool, _ elements: [WBJsonItem]?, _ error: NSError?) -> ())
    {
        let chunkSize = 150
        let chunks = stride(from: 0, to: ids.count, by: chunkSize).map {
            Array(ids[$0..<min($0 + chunkSize, ids.count)])
        }
        
        let dispatchGroup = DispatchGroup()
        var allSuccess = true
        
        for chunk in chunks {
            // FIXME: v2 does not work?
            dispatchGroup.enter()
            self.itemRemote.fetchItems(byIds: chunk, completion: { (success, items) in
                guard success,
                    let items = items else
                {
//                    completion(false, nil, nil)
                    dispatchGroup.leave()
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
                            
                            localObject.addToOneRelationship(WBMaterialElement.self, inverseRelationshipName: "item", foreignKey: localObject.id, realm: realm)
                            break
                        case .inserted(let remoteRecord, let localObject):
                            localObject.saveSyncableProperties(fromSyncable: remoteRecord)
                            realm.add(localObject)
                            
                            localObject.addToOneRelationship(WBMaterialElement.self, inverseRelationshipName: "item", foreignKey: localObject.id, realm: realm)
                            break
                        default:
                            break
                        }
                    }
                }
                
//                completion(true, items, nil)
                dispatchGroup.leave()
            })
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            completion(true, nil, nil)
        })
    }
}