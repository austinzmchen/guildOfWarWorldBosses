//
//  WBMaterialElement.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-11.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import RealmSwift

class WBMaterialElement: WBObject {
    dynamic var category: Int = -1
    dynamic var count: Int = -1
    dynamic var item: WBItem?
    
    override func saveSyncableProperties(fromSyncable syncable: WBRemoteRecordSyncableType) {
        guard let rRecord = syncable as? WBJsonMaterialElement else {
            return
        }
        
        self.category = rRecord.category ?? -1
        self.count = rRecord.count ?? -1
    }
}
