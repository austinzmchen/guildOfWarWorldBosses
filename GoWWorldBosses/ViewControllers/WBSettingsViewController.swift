//
//  WBSettingsViewController.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-09-13.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit

class WBSettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBAction func doneButtonTapped(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var isNotificationTurnedOnInSettings = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplicationWillEnterForegroundNotification, object: nil)
    }

    func appDidBecomeActive() {
        guard let settings = UIApplication.sharedApplication().currentUserNotificationSettings()
            where settings.types != .None else
        {
            isNotificationTurnedOnInSettings = false
            self.tableView.reloadData()
            return
        }
        isNotificationTurnedOnInSettings = true
        self.tableView.reloadData()
    }
}

extension WBSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 71.5
        } else {
            return 50.0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let noteCell = tableView.dequeueReusableCellWithIdentifier("noteCell") as! WBSettingsNotificationTableViewCell
            noteCell.toggleSwitch.on = isNotificationTurnedOnInSettings
            return noteCell
        } else {
            return tableView.dequeueReusableCellWithIdentifier("aboutCell")!
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        } else if indexPath.row == 1 {
            self.performSegueWithIdentifier("pushToAboutVC", sender: nil)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}