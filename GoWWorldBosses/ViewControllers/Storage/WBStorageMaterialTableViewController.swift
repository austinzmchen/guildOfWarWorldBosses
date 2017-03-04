//
//  WBStorageMaterialTableViewController.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2017-03-03.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

class WBStorageMaterialTableViewController: WBStorageGeneralTableViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! WBStorageItemTableViewCell
        
        guard let items = self.viewModel?.items, indexPath.row < items.count,
            let item = items[indexPath.row] as? WBMaterialElement else {
                return cell
        }
        
        // Configure the cell...
        cell.mainTitleLabel.text = item.item?.name
        cell.subTitleLabel.text = String(format: "%d", item.count)
        if let imageUrlString = item.item?.icon {
            cell.leftImageView.sd_setImage(with: URL(string: imageUrlString))
        }
        
        return cell
    }
}
