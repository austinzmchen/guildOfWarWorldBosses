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
    @IBAction func doneButtonTapped(_ sender: AnyObject) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    var isNotificationTurnedOnInSettings = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }

    func appDidBecomeActive() {
        guard let settings = UIApplication.shared.currentUserNotificationSettings, settings.types != UIUserNotificationType() else
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 71.5
        } else {
            return 50.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let noteCell = tableView.dequeueReusableCell(withIdentifier: "noteCell") as! WBSettingsNotificationTableViewCell
            noteCell.toggleSwitch.isOn = isNotificationTurnedOnInSettings
            return noteCell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "aboutCell")!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        } else if indexPath.row == 1 {
            self.performSegue(withIdentifier: "pushToAboutVC", sender: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
