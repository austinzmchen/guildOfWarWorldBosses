//
//  WBItem.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-11.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class WBItem: WBObject, WBItemTypeProtocol {
    
    @objc dynamic var name: String?
    @objc dynamic var descriptionText: String?
    @objc dynamic var icon: String?
    @objc dynamic var type: String?
    @objc dynamic var level: Int = -1
    @objc dynamic var count: Int = -1
    @objc dynamic var flags: String?
    @objc dynamic var rarity: String?
    @objc dynamic var vendorValue: Int = -1
    @objc dynamic var _details: NSData? = nil
    
    override func saveSyncableProperties(fromSyncable syncable: WBRemoteRecordSyncableType) {
        guard let rRecord = syncable as? WBJsonItem else {
            return
        }
        
        self.name = rRecord.name
        self.descriptionText = rRecord.descriptionText
        self.icon = rRecord.icon
        self.type = rRecord.type
        self.level = rRecord.level ?? -1
        
        if let fs = rRecord.flags {
            flags = fs.joined(separator: ",")
        }
        self.rarity = rRecord.rarity
        self.vendorValue = rRecord.vendorValue ?? -1
        
        _details = rRecord.details?.toJSONString()?.data(using: String.Encoding.utf8) as NSData?
    }
}
