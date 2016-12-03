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

    @IBAction func leftBarButtonTapped(_ sender: Any) {
        viewDelegate?.toggleDrawerView()
    }
    
    @IBAction func rightBarButtonTapped(_ sender: Any) {
        let settingsNavVC = WBStoryboardFactory.settingsStoryboard.instantiateViewController(withIdentifier: "settingsNavVC")
        self.present(settingsNavVC, animated: true, completion: nil)
    }
    
    weak var delegate: WBDrawerViewControllerDelegate?
    weak var viewDelegate: WBDrawerMasterViewControllerDelegate?
    
    fileprivate var drawerItems: [WBDrawerItem] = {
        return [
            WBDrawerItem(normalImageName: "", selectedImageName: "", title: "Boss Timers", storyboardFileName: "", storyboardID: ""),
            WBDrawerItem(normalImageName: "", selectedImageName: "", title: "Storage", storyboardFileName: "", storyboardID: "")
            ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
}

extension WBDrawerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.drawerItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "drawerTableCell") as! WBDrawerTableViewCell
        cell.mainTitleLabel.text = drawerItems[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = drawerItems[indexPath.row]
        self.delegate?.didSelect(drawerItem: item, atIndex: indexPath.row)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
