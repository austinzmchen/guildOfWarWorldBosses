//
//  NSDate+Plus.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-08-20.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation

let wb1Minute: Int = 60
//let wb15Minutes: Int = 15 * 60
let wb15Minutes: Int = 1 * 60
let wb1Hour: Int = 60 * 60
let wb1Day: Int = wb1Hour * 24

extension NSDate {
    static func dateByHoursAndMinutes(hours hours:Int, minutes:Int, seconds: Int = 0) -> NSDate {
        let d: NSDate = NSDate(timeIntervalSince1970: 0)
        let cal: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        let date: NSDate = cal.dateBySettingHour(hours, minute: minutes, second: seconds, ofDate: d, options: NSCalendarOptions())!
        
        return date
    }
    
    static var wbNow: Int {
        let now = NSDate() // in utc timezone
        let hours = NSCalendar.currentCalendar().component(.Hour, fromDate: now)
        let minutes = NSCalendar.currentCalendar().component(.Minute, fromDate: now)
        let seconds = NSCalendar.currentCalendar().component(.Second, fromDate: now)
        return (hours * wb1Hour + minutes * wb1Minute + seconds)
    }
}