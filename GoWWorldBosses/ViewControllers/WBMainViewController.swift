//
//  WBMainViewController.swift
//  TimerCountDown
//
//  Created by Austin Chen on 2016-08-14.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit

class WBMainViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var bosses: [WBBoss] = WBBossFactory.creatBosses()
    var timer1: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // set navigation bar
        let titleImageView = UIImageView(image: UIImage(named: "dragon"))
        titleImageView.contentMode = .ScaleAspectFit
        var f = titleImageView.frame
        f.size = CGSize(width: 38.0, height: 38.0)
        titleImageView.frame = f
        self.navigationItem.titleView = titleImageView
        
        // set up table
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // set up coming back to foreground
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(initializeBosses), name: UIApplicationDidBecomeActiveNotification, object: nil)
        // set up coming back to foreground
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(resignActive), name: UIApplicationWillResignActiveNotification, object: nil)
        
        self.initializeBosses()
    }

    func initializeBosses() {
        // set up timer
        self.timer1 = NSTimer(timeInterval: 0.9, target: self, selector: #selector(timerFiredPerSecond), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(self.timer1!, forMode: NSRunLoopCommonModes)

        self.updateBosses()
        
        // sorting
        let n = NSDate.wbNow
        self.bosses.sortInPlace{
            if $0.isActive != $1.isActive { // when one of them is not active
                return Int($0.isActive) > Int($1.isActive)
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
    
    func resignActive() {
        self.timer1?.invalidate()
    }
    
    func updateBosses() {
        let n = NSDate.wbNow
        for boss in bosses {
            boss.update(n)
        }
    }
    
    func timerFiredPerSecond() {
        while let l = self.bosses[0].latestSpawnTime
            where self.bosses[0].isActive && NSDate.wbNow > l + wb15Minutes
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
    }
    
    func updateCell(cell:WBMainTableViewCell, atIndexPath indexPath:NSIndexPath) {
        let boss = self.bosses[indexPath.row]
        
        // set count down
        if boss.isActive {
            cell.countDownLabel.textColor = UIColor(red: 117/255.0, green: 214/255.0, blue: 17/255.0, alpha: 1)
            cell.countDownLabel.text = "ACTIVE"
        } else {
            let countDown = boss.secondsTilNextSpawnTime()
            if countDown < 15 * 60 // under 15 minutes
            {
                cell.countDownLabel.textColor = UIColor.redColor()
            } else {
                cell.countDownLabel.textColor = UIColor.whiteColor()
            }
            cell.countDownLabel.text = countDown.nextSpawnTimeCountDownStringFromDate()
        }
        cell.countDownLabel.setNeedsLayout()
        
        // set next spawn time
        cell.spawnTimeLabel.text = boss.nextSpawnTimeString
    }
}

extension WBMainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bosses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mainTableViewCell", forIndexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let boss = self.bosses[indexPath.row]
        let cell = cell as! WBMainTableViewCell
        // bind dataSource
        cell.boss = boss
        // update property
        cell.nameLabel.text = boss.name
        cell.bossImageView.image = UIImage(named: boss.name)
        cell.favButton.selected = boss.faved
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
        } else {
            boss.cancelNotification()
        }
    }
}

 