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
        if let lst = lastSpawnTime {
            let seconds = NSDate.wbNow.timeIntervalSinceDate(lst)
            if seconds < 15 * 60 // 15 minutes 
            {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    var lastSpawnTime: NSDate? {
        var lst: NSDate? = nil
        let interval = NSDate.wbNow.timeIntervalSinceDate(self.firstSpawnTime)
        if interval > 0 {
            let everyPatternHours = Int(interval) / self.spawnPattern.rawValue
            lst = NSDate(timeInterval: Double(everyPatternHours * self.spawnPattern.rawValue), sinceDate: self.firstSpawnTime)
        } else {
            lst = self.firstSpawnTime
        }
        return lst
    }
    
    var nextSpawnTime: NSDate {
        if let lst = lastSpawnTime {
            return NSDate(timeInterval: Double(self.spawnPattern.rawValue), sinceDate: lst)
        } else {
            return self.firstSpawnTime
        }
    }
}

// global, to optimize
let formatter = NSDateFormatter()
func getFormatter() -> NSDateFormatter {
    formatter.dateFormat = "hh:mma"
    formatter.AMSymbol = "AM"
    formatter.PMSymbol = "PM"
    return formatter
}

extension WBBoss {
    var nextSpawnTimeString: String {
        // return time in local time zone
        let timeZoneoffset: Int = NSTimeZone.localTimeZone().secondsFromGMT
        let d = NSDate(timeInterval: Double(timeZoneoffset), sinceDate: self.nextSpawnTime)

        let dateString = getFormatter().stringFromDate(d)
        return dateString
    }
    
    func nextSpawnTimeCountDown(currentDate: NSDate) -> Int {
        let totalSeconds: Int = Int(self.nextSpawnTime.timeIntervalSinceDate(currentDate))
        return totalSeconds
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
