//
//  WBMainViewController.swift
//  TimerCountDown
//
//  Created by Austin Chen on 2016-08-14.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit

class WBMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var bosses: [WBBoss] = WBBossFactory.creatBosses()
    var timer1: NSTimer?
    var timer2: NSTimer?
    
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
        
        // set up timer
        self.timer1 = NSTimer(timeInterval: 0.9, target: self, selector: #selector(timerFiredPerSecond), userInfo: nil, repeats: true)
        self.timer2 = NSTimer(timeInterval: 59, target: self, selector: #selector(timerFiredPerMinute), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(self.timer1!, forMode: NSRunLoopCommonModes)
        NSRunLoop.currentRunLoop().addTimer(self.timer2!, forMode: NSRunLoopCommonModes)
    }
    
    func timerFiredPerSecond() {
        if let indexPaths = self.tableView.indexPathsForVisibleRows {
            // self.tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
            for ip in indexPaths {
                let boss = self.bosses[ip.row]
                // set count down
                let cell = self.tableView.cellForRowAtIndexPath(ip) as! WBMainTableViewCell
                if boss.isActive {
                    cell.countDownLabel.textColor = UIColor(red: 117/255.0, green: 214/255.0, blue: 17/255.0, alpha: 1)
                    cell.countDownLabel.text = "ACTIVE"
                } else {
                    let countDown = boss.nextSpawnTimeCountDown(NSDate.wbNow)
                    if countDown < 15 * 60 // under 15 minutes
                    {
                        cell.countDownLabel.textColor = UIColor.redColor()
                    } else {
                        cell.countDownLabel.textColor = UIColor.whiteColor()
                    }
                    cell.countDownLabel.text = countDown.nextSpawnTimeCountDownStringFromDate()
                }
                cell.countDownLabel.setNeedsLayout()
            }
        }
    }
    
    func timerFiredPerMinute() {
        if let indexPaths = self.tableView.indexPathsForVisibleRows {
            for ip in indexPaths {
                let boss = self.bosses[ip.row]
                // set count down
                let cell = self.tableView.cellForRowAtIndexPath(ip) as! WBMainTableViewCell
                
                // set next spawn time
                cell.spawnTimeLabel.text = boss.nextSpawnTimeString
                cell.spawnTimeLabel.setNeedsLayout()
            }
        }
    }
    
    
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
        cell.nameLabel.text = boss.name
        cell.bossImageView.image = UIImage(named: boss.name)
        
        // set count down
        if boss.isActive {
            cell.countDownLabel.textColor = UIColor(red: 117/255.0, green: 214/255.0, blue: 17/255.0, alpha: 1)
            cell.countDownLabel.text = "ACTIVE"
        } else {
            let countDown = boss.nextSpawnTimeCountDown(NSDate.wbNow)
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

