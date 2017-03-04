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

class WBItem: WBObject {
    dynamic var name: String?
    dynamic var descriptionText: String?
    dynamic var icon: String?
    dynamic var type: String?
    dynamic var level: Int = -1
    dynamic var count: Int = -1
    dynamic var flags: String?
    dynamic var rarity: String?
    
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
    }
}
/*
extension WBItem { // to allow array of strings? come on!
    var flags: [String] {
        get {
            return _flags.map { $0.stringValue }
        }
        set {
            _flags.removeAll()
            _flags.append(contentsOf: newValue.map({RealmString(value: $0)}))
        }
    }
    
    override static func ignoredProperties() -> [String] {
        return ["flags"]
    }
}
*/
