//
//  NSDate+Plus.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-08-20.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation

let wb1Minute: Int = 60
let wb5Minutes: Int = 5 * 60
let wb15Minutes: Int = 15 * 60
//let wb15Minutes: Int = 1 * 60
let wb1Hour: Int = 60 * 60
let wb1Day: Int = wb1Hour * 24

extension Date {
    static func dateByHoursAndMinutes(hours:Int, minutes:Int, seconds: Int = 0) -> Date {
        let d: Date = Date(timeIntervalSince1970: 0)
        let cal: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        let date: Date = (cal as NSCalendar).date(bySettingHour: hours, minute: minutes, second: seconds, of: d, options: NSCalendar.Options())!
        
        return date
    }
    
    static var wbNow: Int {
        let now = Date() // in utc timezone
        let hours = (Calendar.current as NSCalendar).component(.hour, from: now)
        let minutes = (Calendar.current as NSCalendar).component(.minute, from: now)
        let seconds = (Calendar.current as NSCalendar).component(.second, from: now)
        return (hours * wb1Hour + minutes * wb1Minute + seconds)
    }
}
