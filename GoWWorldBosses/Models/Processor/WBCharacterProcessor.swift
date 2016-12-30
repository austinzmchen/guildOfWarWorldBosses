//
//  WBCharacterProcessor.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-30.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import RealmSwift

class WBCharacterProcessor: NSObject {
    let context: WBSyncContext
    
    init (context: WBSyncContext) {
        self.context = context
    }
    
    lazy var characterRemote: WBCharacterRemote = {
        return WBCharacterRemote(remoteSession: self.context.remoteSession)
    }()
    
    func sync(completion: @escaping (_ success: Bool, _ syncedObjects: [AnyObject]?, _ error: NSError?) -> ()) {
        self.characterRemote.fetchCharacterNames { result in
            switch result {
            case .success(let names):
                guard let ns = names else {
                    DispatchQueue.main.async {
                        completion(false, nil, nil)
                    }
                    return
                }
                
                self.characterRemote.fetchCharacters(byNames: ns, completion: { result in
                    switch result {
                    case .success(let characters):
                        guard let cs = characters else
                        {
                            DispatchQueue.main.async {
                                completion(false, nil, nil)
                            }
                            return
                        }
                        
                        let realm = try! Realm()
                        let changes: [WBRemoteRecordChange<WBJsonCharacter, WBCharacter>] = realm.findOrInsert(cs)
                        
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
                            completion(true, cs as [AnyObject]?, nil)
                        }
                        break
                        
                    case .failure(let error):
                        DispatchQueue.main.async {
                            completion(false, nil, nil)
                        }
                        break
                    }
                })
                break
                
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(false, nil, nil)
                }
                break
            }
        }
    }
}
