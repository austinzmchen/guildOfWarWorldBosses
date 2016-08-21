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

class WBBoss: NSObject {
    let name: String
    let firstSpawnTime: NSDate
    let spawnPattern: WBBossSpawnPattern
    
    init(name: String, firstSpawnTime: NSDate, spawnPattern: WBBossSpawnPattern) {
        self.name = name
        self.firstSpawnTime = firstSpawnTime
        self.spawnPattern = spawnPattern
    }
    
    var isActive: Bool {
        return false
    }
    
    var nextSpawnTime: NSDate {
        var dt = self.firstSpawnTime
        repeat {
            dt = NSDate(timeInterval: Double(self.spawnPattern.rawValue), sinceDate: dt)
        } while dt.compare(NSDate.wbNow) == .OrderedDescending
        
        return dt
    }
}

extension WBBoss {
    var nextSpawnTimeString: String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mma"
        formatter.AMSymbol = "AM"
        formatter.PMSymbol = "PM"
        
        let dateString = formatter.stringFromDate(self.nextSpawnTime)
        // print(dateString)   // "04:44PM"
        return dateString
    }
    
    func nextSpawnTimeCountDownStringFromDate(currentDate: NSDate) -> String {
        let totalSeconds: Int = Int(self.nextSpawnTime.timeIntervalSinceDate(currentDate))
        let seconds = totalSeconds % 60
        let minutes = (totalSeconds / 60) % 60
        let hours = totalSeconds / (60 * 60)
        let string = "\(hours):\(minutes):\(seconds)"
        
        return string
    }
}
