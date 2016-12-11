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
    
    var viewModel: WBStorageTableViewModelType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.itemsCount() ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storageItemTableCell", for: indexPath) as! WBStorageItemTableViewCell

        // Configure the cell...
        cell.mainTitleLabel.text = self.viewModel?.mainTitleForItem(atIndex: indexPath.row)
        cell.subTitleLabel.text = self.viewModel?.subTitleForItem(atIndex: indexPath.row)
        if let imageUrlString = self.viewModel?.imageUrlStringForItem(atIndex: indexPath.row) {
            cell.leftImageView.sd_setImage(with: URL(string: imageUrlString))
        }
        
        return cell
    }

}
