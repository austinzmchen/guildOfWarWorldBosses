//
//  WBSettingsNotificationTableViewCell.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-09-14.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit

class WBSettingsNotificationTableViewCell: UITableViewCell {

    @IBAction func switchToggled(sender: AnyObject) {
        if let s = sender as? UISwitch where s.on {
            UIApplication.turnOnLocalNotification()
        } else {
            UIApplication.turnOffLocalNotification()
        }
    }
}
