//
//  WBHighLevelBoss.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-08-29.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation

class WBHighLevelBoss: WBBoss {
    let spawnTimes: [NSDate]
    
    init(name: String, spawnTimes: [NSDate]) {
        self.spawnTimes = spawnTimes
        super.init(name: name, firstSpawnTime: spawnTimes.first!, spawnPattern: .PatternIrregular)
    }
    
    override var lastSpawnTime: NSDate? {
//        var lst: NSDate? = nil
//        for (i, e) in spawnTimes.enumerate() {
//            if NSDate.wbNow.compare(e) == .OrderedAscending {
//                if i > 0 {
//                    lst = self.spawnTimes[i-1]
//                }
//            }
//        }
//        return lst
        
        let nt = NSDate.wbNow
        guard nt.compare(self.firstSpawnTime) == .OrderedAscending else {
            return self.firstSpawnTime
        }

        var a = 0
        var b = spawnTimes.count
        var m = (b - a) / 2
        while a < b && m != a && m != b { // binary search
            if spawnTimes[m].compare(nt) == .OrderedAscending {
                a = m
            } else {
                b = m
            }
            m = (b - a) / 2
        }
        return spawnTimes[a]
    }
    
    override var nextSpawnTime: NSDate {
        if let l = self.lastSpawnTime,
            let i = self.spawnTimes.indexOf(l) {
            return spawnTimes[i + 1]
        } else {
            return spawnTimes[0]
        }
    }
}
