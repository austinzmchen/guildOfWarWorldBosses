//
//  WBStorageGeneralTableViewController.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-28.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage

class WBStorageGeneralTableViewController: UITableViewController {
    
    var walletElements: [WBWalletElement] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let realm = try! Realm()
        
        // Query
        let results = realm.objects(WBWalletElement.self)
        self.walletElements = Array(results)
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walletElements.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storageItemTableCell", for: indexPath) as! WBStorageItemTableViewCell

        // Configure the cell...
        let walletElement = self.walletElements[indexPath.row]
        if let currency = walletElement.currency
        {
            cell.mainTitleLabel.text = currency.name
            cell.subTitleLabel.text = String(format: "%d", walletElement.value)
            cell.leftImageView.sd_setImage(with: URL(string: currency.icon!))
        }

        return cell
    }

}
