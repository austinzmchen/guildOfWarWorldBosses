//
//  WBHighLevelBoss.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-08-29.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import UIKit

class WBHighLevelBoss: WBBoss {
    let spawnTimes: [Int]
    var lastestSpawnTimeIndex: Int = -1
    
    init(name: String, spawnTimes: [(hours: Int, minutes: Int)]) {
        var sTimes: [Int] = []
        let timeZoneoffset: Int = NSTimeZone.local.secondsFromGMT()
        
        for hourMinute in spawnTimes {
            let spawnTimeUTC = hourMinute.hours * wb1Hour + hourMinute.minutes * wb1Minute
            let sp = Int(spawnTimeUTC + timeZoneoffset + wb1Day) % Int(wb1Day)
//            print("first spawn time - \(name):\(sp)")
            sTimes.append(sp)
        }
        self.spawnTimes = sTimes.sorted(by: { $0 < $1 })
        
        let n = Date.wbNow
        for (i, s) in self.spawnTimes.enumerated() {
            if s > n {
                lastestSpawnTimeIndex = i - 1
                break
            }
            if i == self.spawnTimes.count - 1 {
                lastestSpawnTimeIndex = i
            }
        }
        
        super.init(name: name, firstSpt: self.spawnTimes[0], spawnPattern: .patternIrregular)
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
    
    override func update(_ wbNow: Int) {
        if lastestSpawnTimeIndex + 1 < spawnTimes.count {
            if wbNow > spawnTimes[lastestSpawnTimeIndex + 1] {
                lastestSpawnTimeIndex += 1
            }
        } else {
            if wbNow > spawnTimes[0] + wb1Day {
                lastestSpawnTimeIndex = 0
            }
        }
    }

    override func createNotification(alertBody: String) {
        // eg: Karka Queen: 2 - 6 - 10:30 - 15:00 - 18:00 - 23:00
        // add note for past spawn times, but for new days,
        var i = 0
        while i <= lastestSpawnTimeIndex {
            let notification = UILocalNotification()
            notification.repeatInterval = .day
            notification.alertBody = alertBody
            notification.alertAction = "OK"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.userInfo = [kLocalNotificationBossName: self.name]
            
            var sinceNow: Int = 0
            if lastestSpawnTimeIndex == spawnTimes.count - 1 {
                sinceNow = spawnTimes[i] + wb1Day - (spawnTimes[0] + wb1Day) + self.secondsTilNextSpawnTime()
            } else {
                sinceNow = spawnTimes[i] + wb1Day - spawnTimes[lastestSpawnTimeIndex+1] + self.secondsTilNextSpawnTime()
            }
            sinceNow -= wb5Minutes // notify 5 mins before spawning
            notification.fireDate = Date(timeIntervalSinceNow: Double(sinceNow))
            UIApplication.shared.scheduleLocalNotification(notification)
            i += 1
        }
        
        // add note for spawn times left for today
        var sinceNow: Int = self.secondsTilNextSpawnTime()
        i = lastestSpawnTimeIndex + 1
        while i < spawnTimes.count - 1 {
            let notification = UILocalNotification()
            notification.repeatInterval = .day
            notification.alertBody = alertBody
            notification.alertAction = "OK"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.userInfo = [kLocalNotificationBossName: self.name]
            
            sinceNow -= wb5Minutes // notify 5 mins before spawning
            notification.fireDate = Date(timeIntervalSinceNow: Double(sinceNow))
            UIApplication.shared.scheduleLocalNotification(notification)
            
            sinceNow += spawnTimes[i+1] - spawnTimes[i]
            i += 1
        }
    }
}
