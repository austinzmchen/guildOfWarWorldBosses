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
    
    func sync(completion: @escaping (_ success: Bool, _ syncedObjects: [AnyObject]?, _ error: Error?) -> ()) {
        self.syncMaterialElements { (success, elements, error) in
            guard success,
                let elements = elements else
            {
                completion(false, nil, error)
                return
            }
            
            let ids = elements.map{ $0.id }
            self.syncMaterialItems(byIds: ids, completion: { (success, syncedObjects, error) in
                completion(success, syncedObjects, error)
            })
        }
    }
    
    func syncMaterialElements(completion: @escaping (_ success: Bool, _ elements: [WBJsonMaterialElement]?, _ error: Error?) -> ()) {
        self.materialRemote.fetchMaterialElements { result in
            switch result {
            case .success(let elements):
                guard let elements = elements else {
                    DispatchQueue.main.async {
                        completion(false, nil, nil)
                    }
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
                DispatchQueue.main.async {
                    completion(true, elements, nil)
                }
                break
                
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(false, nil, error)
                }
            }
            
        }
    }
    
    func syncMaterialItems(byIds ids:[String], completion: @escaping (_ success: Bool, _ elements: [WBJsonItem]?, _ error: Error?) -> ())
    {
        let chunkSize = 150
        let chunks = stride(from: 0, to: ids.count, by: chunkSize).map {
            Array(ids[$0..<min($0 + chunkSize, ids.count)])
        }
        
        let dispatchGroup = DispatchGroup()
        var err: Error?
        
        for chunk in chunks {
            // FIXME: v2 does not work?
            dispatchGroup.enter()
            self.itemRemote.fetchItems(byIds: chunk, completion: { result in
                switch result {
                case .success(let items):
                    guard let items = items else
                    {
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
                    
                    dispatchGroup.leave()
                    break
                case .failure(let error):
                    dispatchGroup.leave()
                    err = error
                    break
                }
            })
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            completion(true, nil, err)
        })
    }
}
