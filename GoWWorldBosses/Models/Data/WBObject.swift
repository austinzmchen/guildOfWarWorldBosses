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
    dynamic var id: Int64 = -1
    
    convenience init(primaryKey: Int64) {
        self.init()
        self.id = primaryKey
    }
    
    open override class func primaryKey() -> String? {
        return "id"
    }
    
    func saveSyncableProperties(fromSyncable syncable: WBRemoteRecordSyncableType) {
    }
}
