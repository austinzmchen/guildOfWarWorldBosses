//
//  WBDrawerViewController.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-27.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit

protocol WBDrawerViewControllerDelegate: class {
    func didSelect(drawerItem: WBDrawerItem, atIndex index: Int)
}

struct WBDrawerItem {
    let normalImageName: String
    let selectedImageName: String
    let title: String
    let storyboardFileName: String
    let storyboardID: String
}

class WBDrawerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    @IBAction func closeButtonTapped(_ sender: Any) {
        viewDelegate?.toggleDrawerView()
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        let settingsNavVC = WBStoryboardFactory.settingsStoryboard.instantiateViewController(withIdentifier: "settingsNavVC")
        self.present(settingsNavVC, animated: true, completion: nil)
    }
    
    weak var delegate: WBDrawerViewControllerDelegate?
    weak var viewDelegate: WBDrawerMasterViewControllerDelegate?
    var selectedDrawerItem: WBDrawerItem?
    
    fileprivate var drawerItems: [WBDrawerItem] = {
        return [
            WBDrawerItem(normalImageName: "icTimers",
                         selectedImageName: "icTimersOn",
                         title: "Boss Timers",
                         storyboardFileName: "Timer",
                         storyboardID: "timerNavVC"),
            
            WBDrawerItem(normalImageName: "icCharacters",
                         selectedImageName: "icCharactersOn",
                         title: "My Characters",
                         storyboardFileName: "Characters",
                         storyboardID: "charactersNavVC"),
            
            WBDrawerItem(normalImageName: "icStorage",
                         selectedImageName: "icStorageOn",
                         title: "Storage",
                         storyboardFileName: "Storage",
                         storyboardID: "storageNavVC")
            ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true // use custom view to replace nav bar for style reason
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.selectedDrawerItem = drawerItems.first // select timers as default
        self.tableView.reloadData()
    }
}

extension WBDrawerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.drawerItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "drawerTableCell") as! WBDrawerTableViewCell
        let item = drawerItems[indexPath.row]
        if item.title == selectedDrawerItem?.title {
            cell.leftImageView.image = UIImage(named: item.selectedImageName)
        } else {
            cell.leftImageView.image = UIImage(named: item.normalImageName)
        }
        cell.mainTitleLabel.text = item.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = drawerItems[indexPath.row]
        self.delegate?.didSelect(drawerItem: item, atIndex: indexPath.row)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
