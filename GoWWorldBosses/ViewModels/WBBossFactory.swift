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
        let l1 = WBBoss(name: "Svanir Sharman Chief",
                        firstSpawnTime: NSDate.dateByHoursAndMinutes(hours: 0, minutes: 15), spawnPattern: .Pattern2hrs)
        let l2 = WBBoss(name: "Fire Elemental",
                        firstSpawnTime: NSDate.dateByHoursAndMinutes(hours: 0, minutes: 45), spawnPattern: .Pattern2hrs)
        let l3 = WBBoss(name: "Great Jungle Wurm",
                        firstSpawnTime: NSDate.dateByHoursAndMinutes(hours: 1, minutes: 15), spawnPattern: .Pattern2hrs)
        let l4 = WBBoss(name: "Shadow Behemoth",
                        firstSpawnTime: NSDate.dateByHoursAndMinutes(hours: 1, minutes: 45), spawnPattern: .Pattern2hrs)
        
        // 3hrs
        let m1 = WBBoss(name: "Admiral Taidha Covington",
                        firstSpawnTime: NSDate.dateByHoursAndMinutes(hours: 0, minutes: 0), spawnPattern: .Pattern3hrs)
        let m2 = WBBoss(name: "Mega Destroyer",
                        firstSpawnTime: NSDate.dateByHoursAndMinutes(hours: 0, minutes: 30), spawnPattern: .Pattern3hrs)
        let m3 = WBBoss(name: "The Shatterer",
                        firstSpawnTime: NSDate.dateByHoursAndMinutes(hours: 1, minutes: 00), spawnPattern: .Pattern3hrs)
        let m4 = WBBoss(name: "Modniir Ulgoth",
                        firstSpawnTime: NSDate.dateByHoursAndMinutes(hours: 1, minutes: 30), spawnPattern: .Pattern3hrs)
        let m5 = WBBoss(name: "Golem Mark II",
                        firstSpawnTime: NSDate.dateByHoursAndMinutes(hours: 2, minutes: 00), spawnPattern: .Pattern3hrs)
        let m6 = WBBoss(name: "Claw of Jormag",
                        firstSpawnTime: NSDate.dateByHoursAndMinutes(hours: 2, minutes: 30), spawnPattern: .Pattern3hrs)
        
        return [
            l1,l2,l3,l4,
            m1,m2,m3,m4,m5,m6
            
        ]
    }
    
}