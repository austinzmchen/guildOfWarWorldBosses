//
//  WBMainViewController.swift
//  TimerCountDown
//
//  Created by Austin Chen on 2016-08-14.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit

class WBMainViewController: UIViewController, WBDrawerItemViewControllerType {
    
    @IBAction func leftBarButtonTapped(_ sender: Any) {
        viewDelegate?.toggleDrawerView()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var timer1: Timer?
    var bosses: [WBBoss] = WBBossFactory.creatBosses()
//    var bosses: [WBBoss] = WBBossFactory.creatTestBosses()
    weak var viewDelegate: WBDrawerMasterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // self.setNavTitleView()
        let leftBarButtonItem = UIBarButtonItem.barButtonItem(withImageName:"icBurger",
                                                              title: "Boss Timers",
                                                              forTarget: self,
                                                              action: #selector(leftBarButtonTapped(_:)) )
        self.navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
        
        // set up table
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // set up coming back to foreground
        NotificationCenter.default.addObserver(self, selector: #selector(initializeBosses), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        // set up timer
        self.timer1 = Timer(timeInterval: 0.9, target: self, selector: #selector(timerFiredPerSecond), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer1!, forMode: RunLoopMode.commonModes)
        
        self.initializeBosses()
    }

    func initializeBosses() {
        self.updateBosses()
        
        // sorting
        let n = Date.wbNow
        self.bosses.sort{
            if $0.isActive != $1.isActive { // when one of them is not active
                return ($0.isActive ? 1 : 0) > ($1.isActive ? 1 : 0)
            } else {
                if $0.isActive == true,
                    let lst1 = $0.latestSpawnTime,
                    let lst2 = $1.latestSpawnTime {
                    return n - lst1 > n - lst2
                } else {
                    return $0.secondsTilNextSpawnTime() < $1.secondsTilNextSpawnTime()
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func updateBosses() {
        let n = Date.wbNow
        for boss in bosses {
            boss.update(n)
        }
    }
    
    func timerFiredPerSecond() {
        self.updateBosses()
        
        // sorting
        let n = Date.wbNow
        self.bosses.sort{
            if $0.isActive != $1.isActive { // when one of them is not active
                return ($0.isActive ? 1 : 0) > ($1.isActive ? 1 : 0)
            } else {
                if $0.isActive == true,
                    let lst1 = $0.latestSpawnTime,
                    let lst2 = $1.latestSpawnTime {
                    return n - lst1 > n - lst2
                } else {
                    return $0.secondsTilNextSpawnTime() < $1.secondsTilNextSpawnTime()
                }
            }
        }
        self.tableView.reloadData()
        
        /* problem - inifit looping
        let l = self.bosses[0].latestSpawnTime
        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? WBMainTableViewCell
        while let l = l,
            let cell = cell where
            NSDate.wbNow >= l + wb15Minutes - 1 && cell.countDownStyle == WBTableCellCountDownStyle.Active
        { // boss is active, and it is over spawn time for 15 mins
            let boss = self.bosses[0]
            self.bosses.removeFirst()
            self.bosses.append(boss)
            
            self.tableView.beginUpdates()
            self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Top)
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.bosses.count - 1, inSection: 0)], withRowAnimation: .Bottom)
            self.tableView.endUpdates()
        }
        
        if let indexPaths = self.tableView.indexPathsForVisibleRows {
            self.updateBosses()
            for indexPath in indexPaths {
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! WBMainTableViewCell
                self.updateCell(cell, atIndexPath: indexPath)
            }
        }
        */
    }
    
    func updateCell(_ cell:WBMainTableViewCell, atIndexPath indexPath:IndexPath) {
        let boss = self.bosses[indexPath.row]
        
        // set count down
        if boss.isActive {
            cell.countDownStyle = .active
        } else {
            let cd = boss.secondsTilNextSpawnTime()
            if cd < wb15Minutes // under 15 minutes
            {
                cell.countDownStyle = .countDownRed(countDown: cd)
            } else {
                cell.countDownStyle = .countDown(countDown: cd)
            }
        }
        cell.countDownLabel.setNeedsLayout()
        
        // set next spawn time
        cell.spawnTimeLabel.text = boss.nextSpawnTimeString
        
        if let bossNames = WBKeyStore.keyStoreItem?.likedBosses {
            if bossNames.contains(boss.name) {
                cell.favButton.isSelected = true
            }
        }
    }
}

extension WBMainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bosses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainTableViewCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let boss = self.bosses[indexPath.row]
        let cell = cell as! WBMainTableViewCell
        // bind dataSource
        cell.boss = boss
        // update property
        cell.nameLabel.text = boss.name
        cell.bossImageView.image = UIImage(named: boss.name)
        cell.favButton.isSelected = boss.faved
        cell.delegate = self
        
        self.updateCell(cell, atIndexPath: indexPath)
    }
}

let kLocalNotificationBossName = "kLocalNotificationUserBossName"

extension WBMainViewController: WBMainTableViewCellDelegate {
    
    func selectFavorite(isSelected selected: Bool, forBoss boss: WBBoss) {
        boss.faved = selected
        
        if selected {
            boss.createNotification(alertBody: String(format: "%@ is starting soon!", boss.name))
            
            var lBosses = WBKeyStore.keyStoreItem?.likedBosses ?? Set<String>()
            if !lBosses.contains(boss.name) {
                lBosses.insert(boss.name)
            }
            let keyItem = WBKeyStore.keyStoreItem
            WBKeyStore.keyStoreItem = WBKeyStoreItem(likedBosses: lBosses, accountAPIKey: keyItem?.accountAPIKey ?? "")
        } else {
            boss.cancelNotification()
            
            var lBosses = WBKeyStore.keyStoreItem?.likedBosses ?? Set<String>()
            if lBosses.contains(boss.name) {
                lBosses.remove(boss.name)
            }
            let keyItem = WBKeyStore.keyStoreItem
            WBKeyStore.keyStoreItem = WBKeyStoreItem(likedBosses: lBosses, accountAPIKey: keyItem?.accountAPIKey ?? "")
        }
    }
}

 
