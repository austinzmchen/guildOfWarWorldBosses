//
//  Entities.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-23.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import RealmSwift

class WBCurrency: WBObject {
    dynamic var name: String?
    dynamic var descriptionText: String?
    dynamic var icon: String?
//    dynamic var order: Int
    
    override func saveSyncableProperties(fromSyncable syncable: WBRemoteRecordSyncableType) {
        guard let rRecord = syncable as? WBJsonCurrency else {
            return
        }
        
        self.name = rRecord.name
        self.descriptionText = rRecord.descriptionText
        self.icon = rRecord.icon
//        self.order = rRecord.order
    }
}

class WBBankItem: WBObject {
    dynamic var name = ""
    dynamic var descriptionText = ""
    dynamic var icon = ""
    dynamic var type = ""
    dynamic var level = 0
    
    override func saveSyncableProperties(fromSyncable syncable: WBRemoteRecordSyncableType) {
    }
}
