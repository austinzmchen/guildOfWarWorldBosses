//
//  WBBoss.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-08-20.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit
import Foundation

enum WBBossSpawnPattern: Int {
    case pattern2hrs = 7200 // 2 * 60 * 60
    case pattern3hrs = 10800 // 3 * 60 * 60
    case patternIrregular = -1
}

protocol WBBossProtocol {
    var isActive: Bool {get}
    var latestSpawnTime: Int? {get}
    var nextSpawnTime: Int {get}
    func update(_ wbNow: Int)
}

protocol WBBossLocalNotificationProtocol {
    func createNotification(alertBody: String)
    func cancelNotification()
}

class WBBoss: NSObject, WBBossProtocol, WBBossLocalNotificationProtocol {
    let name: String
    let firstSpawnTime: Int
    let spawnPattern: WBBossSpawnPattern
    let locationCode: String
    
    var faved: Bool = false
    var _latestSpawnTime: Int?
    
    init(name: String, firstSpt: Int, spawnPattern: WBBossSpawnPattern, locationCode: String) {
        self.name = name
        self.spawnPattern = spawnPattern
        self.firstSpawnTime = firstSpt
        self.locationCode = locationCode
    }
    
    init(name: String, firstSpawnTime: (hours: Int, minutes: Int), spawnPattern: WBBossSpawnPattern, locationCode: String) {
        self.name = name
        self.spawnPattern = spawnPattern
        
        // return time in local time zone
        let timeZoneoffset: Int = NSTimeZone.local.secondsFromGMT()
        let spawnTimeUTC = (firstSpawnTime.hours * wb1Hour + firstSpawnTime.minutes * wb1Minute)
        self.firstSpawnTime = Int(spawnTimeUTC + timeZoneoffset + wb1Day) % Int(spawnPattern.rawValue)
//        print("first spawn time -\(name):\(self.firstSpawnTime / 60)")
        
        self.locationCode = locationCode
    }

    var isActive: Bool {
        if let l = self.latestSpawnTime, Date.wbNow < l + wb15Minutes {
            return true
        } else {
            return false
        }
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
    
    func update(_ wbNow: Int) {
        if wbNow < self.firstSpawnTime {
            if _latestSpawnTime != nil {
                _latestSpawnTime = self.firstSpawnTime + wb1Day - self.spawnPattern.rawValue
            }
        } else {
            let spawnIndex = (wbNow - self.firstSpawnTime) / self.spawnPattern.rawValue
            _latestSpawnTime = self.firstSpawnTime + spawnIndex * self.spawnPattern.rawValue
        }
    }

    func createNotification(alertBody: String) {
        let num = wb1Day / self.spawnPattern.rawValue
        var i = 0
        while i < num {
            let notification = UILocalNotification()
            notification.repeatInterval = .day
            notification.alertBody = alertBody
            notification.alertAction = "OK"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.userInfo = [kLocalNotificationBossName: self.name]
            
            let sinceNow: Int = self.secondsTilNextSpawnTime() + i * self.spawnPattern.rawValue - wb5Minutes // notify 5 mins before spawning
            notification.fireDate = Date(timeIntervalSinceNow: Double(sinceNow))
            UIApplication.shared.scheduleLocalNotification(notification)
            i += 1
        }
    }
    
    func cancelNotification() {
        for notification in UIApplication.shared.scheduledLocalNotifications ?? [] {
            guard let userInfo = notification.userInfo,
                let bName = userInfo[kLocalNotificationBossName] as? String else {
                    continue
            }
            print(bName)
            if bName == self.name {
                UIApplication.shared.cancelLocalNotification(notification)
            }
        }
    }
}

extension WBBoss {
    var nextSpawnTimeString: String {
        let nst = self.nextSpawnTime % wb1Day
        //let seconds = nst % 60
        let minutes = (nst / 60) % 60
        let hours = nst / (60 * 60)
        let string = String(format: "%d:%02d", hours, minutes) // "\(hours):\(minutes):\(seconds)"
        
        /*
        let postFix: String
        if nst < 12 * wb1Hour {
            postFix = " AM"
        } else {
            postFix = " PM"
        }*/
        return string// + postFix
    }
    
    func secondsTilNextSpawnTime() -> Int {
        return self.nextSpawnTime - Date.wbNow
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
