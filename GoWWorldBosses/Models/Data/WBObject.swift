//
//  WBObject.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-28.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import RealmSwift

class WBObject: Object {
    @objc dynamic var id: String = "wbNull"
    
    convenience init(primaryKey: String) {
        self.init()
        self.id = primaryKey
    }
    
    open override class func primaryKey() -> String? {
        return "id"
    }
    
    func saveSyncableProperties(fromSyncable syncable: WBRemoteRecordSyncableType) {
    }
}

extension WBObject {
    
    func addToOneRelationship<S: WBObject>(_ relationshipEntityType: S.Type,
                              relationshipName: String? = nil, inverseRelationshipName: String? = nil,
                              foreignKeyName: String = "id", foreignKey: String, realm: Realm)
    {
        let localObjects: Results<S> = realm.objects(S.self)
            .filter(NSPredicate(format: "\(foreignKeyName) = %@", foreignKey))
        
        if let object = localObjects.first {
            if let rn = relationshipName {
                self[rn] = object
            }
            
            // if defined
            if let irn = inverseRelationshipName {
                object[irn] = self
            }
        }
    }
}
