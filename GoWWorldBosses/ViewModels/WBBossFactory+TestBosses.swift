//
//  WBBossFactory+TestBosses.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-09-14.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation

extension WBBossFactory {
    static func creatTestBosses() -> [WBBoss] {
        
        let now = NSDate() // in utc timezone
        let hours = NSCalendar.currentCalendar().component(.Hour, fromDate: now)
        let minutes = NSCalendar.currentCalendar().component(.Minute, fromDate: now)
        let firstSpawnMinutes = minutes + 0
        let secondSpawnMinutes = minutes + 1
        
        // 2hrs
        let l1 = WBBoss(name: "Svanir Sharman Chief",
                        firstSpawnTime: (hours: hours, minutes: firstSpawnMinutes), spawnPattern: .Pattern2hrs)
        let l2 = WBBoss(name: "Fire Elemental",
                        firstSpawnTime: (hours: hours, minutes: firstSpawnMinutes), spawnPattern: .Pattern2hrs)
        let l3 = WBBoss(name: "Great Jungle Wurm",
                        firstSpawnTime: (hours: hours, minutes: secondSpawnMinutes), spawnPattern: .Pattern2hrs)
        let l4 = WBBoss(name: "Shadow Behemoth",
                        firstSpawnTime: (hours: hours, minutes: secondSpawnMinutes), spawnPattern: .Pattern2hrs)
        
        return [
            l1,
            l2,
            l3,
            l4
        ]
    }
}