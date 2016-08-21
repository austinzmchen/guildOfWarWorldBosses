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
    var timer: NSTimer?
    
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
        self.timer = NSTimer(timeInterval: 1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
    }
    
    func timerFired() {
        self.tableView.reloadData()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mainTableViewCell", forIndexPath: indexPath) as! WBMainTableViewCell
        let boss = self.bosses[indexPath.row]
        cell.nameLabel.text = boss.name
        cell.bossImageView.image = UIImage(named: boss.name)
        
        // set count down
        cell.countDownLabel.text = boss.nextSpawnTimeCountDownStringFromDate(NSDate.wbNow)
        
        // set next spawn time
        cell.spawnTimeLabel.text = boss.nextSpawnTimeString
        
        return cell
    }
    
}

