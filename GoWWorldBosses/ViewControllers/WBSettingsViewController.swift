//
//  WBSettingsViewController.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-09-13.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit

private struct WBSettingsItem {
    var title: String
    var subtitle: String
    var segueId: String
}

class WBSettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBAction func doneButtonTapped(_ sender: AnyObject) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    var isNotificationTurnedOnInSettings = true
    fileprivate var settingItems: [WBSettingsItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        settingItems = [WBSettingsItem(title: "Notifications", subtitle: "", segueId: ""),
                        WBSettingsItem(title: "About", subtitle: AppConfiguration.appVersion(), segueId: "pushToAboutVC"),
                        WBSettingsItem(title: "Help", subtitle: "", segueId: "")]
        
        if WBKeyStore.isAccountAvailable {
            settingItems.insert(WBSettingsItem(title: "API Key", subtitle: "", segueId: "pushToAPIKeyVC"), at: 1)
        }
        tableView.reloadData()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushToAPIKeyVC" {
            let vc = segue.destination
            vc.title = "API Key"
        }
    }
}

extension WBSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if settingItems[indexPath.row].title == "Notifications"  {
            return 71.5
        } else {
            return 50.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = nil
        
        if indexPath.row == 0 {
            let noteCell = tableView.dequeueReusableCell(withIdentifier: "noteCell") as! WBSettingsNotificationTableViewCell
            noteCell.toggleSwitch.isOn = isNotificationTurnedOnInSettings
            cell = noteCell
        } else {
            let settingsCell = tableView.dequeueReusableCell(withIdentifier: "settingsCell") as! WBSettingsTableViewCell
            let settingsitem = settingItems[indexPath.row]
            settingsCell.mainLabel.text = settingsitem.title
            settingsCell.subLabel.text = settingsitem.subtitle
            settingsCell.separaterView.isHidden = (indexPath.row + 1 == settingItems.count) 
            
            cell = settingsCell
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        } else if indexPath.row + 1 == settingItems.count {
            UIApplication.shared.openURL(URL(string: "mailto:help@mytyria.com")!)
        } else {
            let settingsitem = settingItems[indexPath.row]
            self.performSegue(withIdentifier: settingsitem.segueId, sender: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
