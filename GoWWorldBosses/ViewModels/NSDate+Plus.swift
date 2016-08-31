//
//  NSDate+Plus.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-08-20.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation

extension NSDate {
    static func dateByHoursAndMinutes(hours hours:Int, minutes:Int, seconds: Int = 0) -> NSDate {
        let d: NSDate = NSDate(timeIntervalSince1970: 0)
        let cal: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        let date: NSDate = cal.dateBySettingHour(hours, minute: minutes, second: seconds, ofDate: d, options: NSCalendarOptions())!
        
        return date
    }
    
    static var wbNow: NSDate {
        let now = NSDate() // in utc timezone
        let hours = NSCalendar.currentCalendar().component(.Hour, fromDate: now)
        let minutes = NSCalendar.currentCalendar().component(.Minute, fromDate: now)
        let seconds = NSCalendar.currentCalendar().component(.Second, fromDate: now)
        return NSDate.dateByHoursAndMinutes(hours: hours, minutes: minutes, seconds: seconds)
    }
}