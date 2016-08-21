//
//  NSDate+Plus.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-08-20.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation

extension NSDate {
    static func dateByHoursAndMinutes(hours hours:Int, minutes:Int) -> NSDate {
        // Initialize Date components
        let c = NSDateComponents()
        c.year = 0
        c.month = 0
        c.day = 0
        c.hour = hours
        c.minute = minutes
        c.second = 0
        
        // Get NSDate given the above date components
        let date = NSCalendar(identifier: NSCalendarIdentifierGregorian)?.dateFromComponents(c)
        return date!
    }
    
    static var wbNow: NSDate {
        let now = NSDate()
        let hours = NSCalendar.currentCalendar().component(.Hour, fromDate: now)
        let minutes = NSCalendar.currentCalendar().component(.Minute, fromDate: now)
        return NSDate.dateByHoursAndMinutes(hours:hours, minutes:minutes)
    }
}