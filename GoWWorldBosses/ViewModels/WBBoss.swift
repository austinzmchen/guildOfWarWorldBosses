//
//  WBBoss.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-08-20.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation

enum WBBossSpawnPattern: Int {
    case Pattern2hrs = 7200 // 2 * 60 * 60
    case Pattern3hrs = 10800 // 3 * 60 * 60
    case PatternIrregular = -1
}

protocol WBBossProtocol {
    var isActive: Bool {get}
    var latestSpawnTime: Int? {get}
    var nextSpawnTime: Int {get}
    func update(wbNow: Int)
}

class WBBoss: NSObject, WBBossProtocol {
    let name: String
    let firstSpawnTime: Int
    let spawnPattern: WBBossSpawnPattern
    var faved: Bool = false
    var _latestSpawnTime: Int?
    var isActive: Bool = false
    
    init(name: String, firstSpawnTime: (hours: Int, minutes: Int), spawnPattern: WBBossSpawnPattern) {
        self.name = name
        self.firstSpawnTime = (firstSpawnTime.hours * wb1Hour + firstSpawnTime.minutes * wb1Minute)
        self.spawnPattern = spawnPattern
    }
    
    var latestSpawnTime: Int? {
        return _latestSpawnTime
    }

    var nextSpawnTime: Int {
        if let l = self.latestSpawnTime {
            return l + spawnPattern.rawValue
        } else {
            return self.firstSpawnTime
        }
    }
    
    func update(wbNow: Int) {
        if wbNow < self.firstSpawnTime {
            if _latestSpawnTime != nil {
                _latestSpawnTime = self.firstSpawnTime + wb1Day - self.spawnPattern.rawValue
            }
        } else {
            let spawnIndex = (wbNow - self.firstSpawnTime) / self.spawnPattern.rawValue
            _latestSpawnTime = self.firstSpawnTime + spawnIndex * self.spawnPattern.rawValue
        }
        
        self.updateIsActive()
    }
    
    func updateIsActive() {
        if let l = self.latestSpawnTime where NSDate.wbNow < l + wb15Minutes {
            isActive = true
        } else {
            isActive = false
        }
    }
}

extension WBBoss {
    var nextSpawnTimeString: String {
        let nst = self.nextSpawnTime % wb1Day
        let seconds = nst % 60
        let minutes = (nst / 60) % 60
        let hours = nst / (60 * 60)
        let string = String(format: "%d:%02d:%02d", hours, minutes, seconds) // "\(hours):\(minutes):\(seconds)"
        
        let postFix: String
        if nst < 12 * wb1Hour {
            postFix = " AM"
        } else {
            postFix = " PM"
        }
        return string + postFix
    }
    
    func secondsTilNextSpawnTime() -> Int {
        return self.nextSpawnTime - NSDate.wbNow
    }
}

extension Int {
    func nextSpawnTimeCountDownStringFromDate() -> String {
        let seconds = self % 60
        let minutes = (self / 60) % 60
        let hours = self / (60 * 60)
        var string = ""
        if hours > 0 {
            string = String(format: "%d:%02d:%02d", hours, minutes, seconds) //"\(hours):\(minutes):\(seconds)"
        } else {
            string = String(format: "%02d:%02d", minutes, seconds) // "\(minutes):\(seconds)"
        }
        return string
    }
}
