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
    dynamic var order: Int = -1
    
    override func saveSyncableProperties(fromSyncable syncable: WBRemoteRecordSyncableType) {
        guard let rRecord = syncable as? WBJsonCurrency else {
            return
        }
        
        self.name = rRecord.name
        self.descriptionText = rRecord.descriptionText
        self.icon = rRecord.icon
        self.order = rRecord.order ?? -1
    }
}

class WBBankItem: WBObject {
    dynamic var name: String?
    dynamic var descriptionText: String?
    dynamic var icon: String?
    dynamic var type: String?
    dynamic var level: Int = -1
    
    override func saveSyncableProperties(fromSyncable syncable: WBRemoteRecordSyncableType) {
        guard let rRecord = syncable as? WBJsonBankItem else {
            return
        }
        
        self.name = rRecord.name
        self.descriptionText = rRecord.descriptionText
        self.icon = rRecord.icon
        self.type = rRecord.type
        self.level = rRecord.level ?? -1
    }
}

class WBCharacter: WBObject {
    dynamic var name: String?
    dynamic var race: String?
    dynamic var gender: String?
    dynamic var profession: String?
    dynamic var level: Int = -1
    dynamic var age: Int = -1
    dynamic var death: Int = -1
    dynamic var created: Date?
    
    override func saveSyncableProperties(fromSyncable syncable: WBRemoteRecordSyncableType) {
        guard let rRecord = syncable as? WBJsonCharacter else {
            return
        }
        
        self.name = rRecord.name
        self.race = rRecord.race
        self.gender = rRecord.gender
        self.profession = rRecord.profession
        self.level = rRecord.level ?? -1
        self.age = rRecord.age ?? -1
        self.death = rRecord.death ?? -1
        self.created = rRecord.created
    }
}

