//
//  WBAccount.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-15.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import RealmSwift

class WBAccount: WBObject {
    dynamic var name: String?
    dynamic var world: Int = -1
    dynamic var created: Date?
    dynamic var access: String?
    dynamic var commander: Bool = false
    dynamic var fractalLevel: Int = -1
    dynamic var daily_ap: Int = -1
    dynamic var monthly_ap: Int = -1
    dynamic var wvw_rank: Int = -1
    
    override func saveSyncableProperties(fromSyncable syncable: WBRemoteRecordSyncableType) {
        guard let rRecord = syncable as? WBJsonAccount else {
            return
        }
        
        self.name = rRecord.name
        self.world = rRecord.world ?? -1
        // self.created = rRecord.created
        self.access = rRecord.access
        self.commander = rRecord.commander ?? false
        self.fractalLevel = rRecord.fractalLevel ?? -1
        self.daily_ap = rRecord.daily_ap ?? -1
        self.monthly_ap = rRecord.monthly_ap ?? -1
        self.wvw_rank = rRecord.wvw_rank ?? -1
    }
}
