//
//  UILocalNotificationPlus.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-09-14.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit

extension UIApplication {
    static func turnOnLocalNotification() {
        // add local notification feature
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
    static func turnOffLocalNotification() {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
}