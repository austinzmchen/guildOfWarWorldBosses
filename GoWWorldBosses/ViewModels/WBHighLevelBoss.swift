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
        var lst: NSDate? = nil
        for var i = 0; i < spawnTimes.count; i+=1 {
            if NSDate.wbNow.compare(spawnTimes[i]) == .OrderedAscending {
                if i > 0 {
                    lst = self.spawnTimes[i-1]
                    break
                }
            }
            if (i == spawnTimes.count - 1) { // if current time is later than the last one of spawnTimes
                lst = self.spawnTimes[i]
            }
        }
        
        return lst
    }
    
    override var nextSpawnTime: NSDate {
        if let l = self.lastSpawnTime,
            let i = self.spawnTimes.indexOf(l) {
            if i < spawnTimes.count - 1 {
                return spawnTimes[i + 1]
            } else {
                return NSDate(timeInterval: 24 * 3600.0, sinceDate: spawnTimes[0])
            }
        } else {
            return spawnTimes[0]
        }
    }
}
