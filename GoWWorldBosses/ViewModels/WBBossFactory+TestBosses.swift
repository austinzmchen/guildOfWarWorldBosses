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
        
        let now = Date() // in utc timezone
        let hours = (Calendar.current as NSCalendar).component(.hour, from: now)
        let minutes = (Calendar.current as NSCalendar).component(.minute, from: now)
        let firstSpawnMinutes = minutes + 0
        let secondSpawnMinutes = minutes + 1
        
        // 2hrs
        let l1 = WBBoss(name: "Svanir Shaman Chief",
                        firstSpawnTime: (hours: hours, minutes: firstSpawnMinutes), spawnPattern: .pattern2hrs, locationCode: "[&BMIDAAA=]")
        let l2 = WBBoss(name: "Fire Elemental",
                        firstSpawnTime: (hours: hours, minutes: firstSpawnMinutes), spawnPattern: .pattern2hrs, locationCode: "[&BEcAAAA=]")
        let l3 = WBBoss(name: "Great Jungle Wurm",
                        firstSpawnTime: (hours: hours, minutes: secondSpawnMinutes), spawnPattern: .pattern2hrs, locationCode: "[&BEEFAAA=]")
        let l4 = WBBoss(name: "Shadow Behemoth",
                        firstSpawnTime: (hours: hours, minutes: secondSpawnMinutes), spawnPattern: .pattern2hrs, locationCode: "[&BPcAAAA=]")
        
        return [
            l1,
            l2,
            l3,
            l4
        ]
    }
}
