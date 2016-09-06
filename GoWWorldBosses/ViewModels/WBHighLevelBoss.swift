//
//  WBHighLevelBoss.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-08-29.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation

class WBHighLevelBoss: WBBoss {
    let spawnTimes: [Int]
    var lastestSpawnTimeIndex: Int = -1
    
    init(name: String, spawnTimes: [(hours: Int, minutes: Int)]) {
        var sTimes: [Int] = []
        for hourMinute in spawnTimes {
            sTimes.append(hourMinute.hours * wb1Hour + hourMinute.minutes * wb1Minute)
        }
        self.spawnTimes = sTimes
        
        let n = NSDate.wbNow
        for (i, s) in self.spawnTimes.enumerate() {
            if s > n {
                lastestSpawnTimeIndex = i - 1
                break
            }
            if i == self.spawnTimes.count - 1 {
                lastestSpawnTimeIndex = i
            }
        }
        
        super.init(name: name, firstSpawnTime: spawnTimes[0], spawnPattern: .PatternIrregular)
    }
    
    override var latestSpawnTime: Int? {
        if self.lastestSpawnTimeIndex >= 0 {
            return self.spawnTimes[self.lastestSpawnTimeIndex]
        } else {
            return nil
        }
    }
    
    override var nextSpawnTime: Int {
        if self.lastestSpawnTimeIndex + 1 == self.spawnTimes.count {
            return self.firstSpawnTime + wb1Day // on the following day
        } else if self.lastestSpawnTimeIndex >= 0 {
            return self.spawnTimes[self.lastestSpawnTimeIndex + 1]
        } else {
            return self.firstSpawnTime
        }
    }
    
    override func update(wbNow: Int) {
        if lastestSpawnTimeIndex + 1 < spawnTimes.count {
            if wbNow > spawnTimes[lastestSpawnTimeIndex + 1] {
                lastestSpawnTimeIndex += 1
            }
        } else {
            if wbNow > spawnTimes[0] + wb1Day {
                lastestSpawnTimeIndex == 0
            }
        }
    }
}
