//
//  Entities.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-23.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import RealmSwift

class WBWalletElement: WBObject {
    @objc dynamic var value: Int = -1
    @objc dynamic var currency: WBCurrency?
    
    override func saveSyncableProperties(fromSyncable syncable: WBRemoteRecordSyncableType) {
        guard let rRecord = syncable as? WBJsonWalletElement else {
            return
        }
        
        self.value = rRecord.value ?? -1
    }
}


class WBCurrency: WBObject {
    @objc dynamic var name: String?
    @objc dynamic var descriptionText: String?
    @objc dynamic var icon: String?
    @objc dynamic var order: Int = -1
    @objc dynamic var count: Int = -1
    @objc dynamic var walletElement: WBWalletElement?
    
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

class WBBankElement: WBObject {
    @objc dynamic var count: Int = -1
    @objc dynamic var binding: String?
    @objc dynamic var item: WBItem?
    
    override func saveSyncableProperties(fromSyncable syncable: WBRemoteRecordSyncableType) {
        guard let rRecord = syncable as? WBJsonBankElement else {
            return
        }
        
        self.count = rRecord.count ?? -1
        self.binding = rRecord.binding
    }
}

class WBCharacter: WBObject {
    @objc dynamic var name: String?
    @objc dynamic var race: String?
    @objc dynamic var gender: String?
    @objc dynamic var profession: String?
    @objc dynamic var level: Int = -1
    @objc dynamic var age: Int = -1
    @objc dynamic var death: Int = -1
    @objc dynamic var created: Date?
    
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

