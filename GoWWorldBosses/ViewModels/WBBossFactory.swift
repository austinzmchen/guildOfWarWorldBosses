//
//  WBBossFactory.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-08-20.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit

class WBBossFactory: NSObject {
    
    static func creatBosses() -> [WBBoss] {
        // 2hrs
        let l1 = WBBoss(name: "Svanir Shaman Chief",
                        firstSpawnTime: (hours: 0, minutes: 15), spawnPattern: .pattern2hrs,
                        locationCode: "[&BMIDAAA=]")
        let l2 = WBBoss(name: "Fire Elemental",
                        firstSpawnTime: (hours: 0, minutes: 45), spawnPattern: .pattern2hrs,
                        locationCode: "[&BEcAAAA=]")
        let l3 = WBBoss(name: "Great Jungle Wurm",
                        firstSpawnTime: (hours: 1, minutes: 15), spawnPattern: .pattern2hrs,
                        locationCode: "[&BEEFAAA=]")
        let l4 = WBBoss(name: "Shadow Behemoth",
                        firstSpawnTime: (hours: 1, minutes: 45), spawnPattern: .pattern2hrs,
                        locationCode: "[&BPcAAAA=]")
        
        // 3hrs
        let m1 = WBBoss(name: "Admiral Taidha Covington",
                        firstSpawnTime: (hours: 0, minutes: 0), spawnPattern: .pattern3hrs,
                        locationCode: "[&BKgBAAA=]")
        let m2 = WBBoss(name: "Mega Destroyer",
                        firstSpawnTime: (hours: 0, minutes: 30), spawnPattern: .pattern3hrs,
                        locationCode: "[&BM0CAAA=]")
        let m3 = WBBoss(name: "The Shatterer",
                        firstSpawnTime: (hours: 1, minutes: 00), spawnPattern: .pattern3hrs,
                        locationCode: "[&BE4DAAA=]")
        let m4 = WBBoss(name: "Modniir Ulgoth",
                        firstSpawnTime: (hours: 1, minutes: 30), spawnPattern: .pattern3hrs,
                        locationCode: "[&BLAAAAA=]")
        let m5 = WBBoss(name: "Golem Mark II",
                        firstSpawnTime: (hours: 2, minutes: 00), spawnPattern: .pattern3hrs,
                        locationCode: "[&BNQCAAA=]")
        let m6 = WBBoss(name: "Claw of Jormag",
                        firstSpawnTime: (hours: 2, minutes: 30), spawnPattern: .pattern3hrs,
                        locationCode: "[&BHoCAAA=]")
        
        // high level bosses
        let h1 = WBHighLevelBoss(name: "Tequatl The Sunless",
                                 spawnTimes: [
                                    (hours: 0, minutes: 0),
                                    (hours: 3, minutes: 0),
                                    (hours: 7, minutes: 0),
                                    (hours: 11, minutes: 30),
                                    (hours: 16, minutes: 0),
                                    (hours: 19, minutes: 0)],
                                locationCode: "[&BNABAAA=]")
        
        let h2 = WBHighLevelBoss(name: "Evolved Jungle Wurm",
                                 spawnTimes: [
                                    (hours: 1, minutes: 0),
                                    (hours: 4, minutes: 0),
                                    (hours: 8, minutes: 0),
                                    (hours: 12, minutes: 30),
                                    (hours: 17, minutes: 0),
                                    (hours: 20, minutes: 0)],
                                locationCode: "[&BKoBAAA=]")
        
        let h3 = WBHighLevelBoss(name: "Karka Queen",
                                 spawnTimes: [
                                    (hours: 2, minutes: 0),
                                    (hours: 6, minutes: 0),
                                    (hours: 10, minutes: 30),
                                    (hours: 15, minutes: 0),
                                    (hours: 18, minutes: 0),
                                    (hours: 23, minutes: 0)],
                                 locationCode: "[&BNUGAAA=]")
        
        return [
            l1,l2,l3,l4,
            m1,m2,m3,m4,m5,m6,
            h1,h2,h3
        ]
    }
    
}
