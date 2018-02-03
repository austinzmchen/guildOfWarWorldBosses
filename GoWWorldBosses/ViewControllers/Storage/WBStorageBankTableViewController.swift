//
//  WBStorageBankTableViewController.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-04.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage
import ACKit

class WBStorageBankTableViewController: WBStorageGeneralTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerCellNib(WBStorageItemTableViewCell.self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! WBStorageItemTableViewCell
        
        guard let items = self.viewModel?.items, indexPath.row < items.count,
            let item = items[indexPath.row] as? WBBankElement else {
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let items = self.viewModel?.items, indexPath.row < items.count,
            let item = items[indexPath.row] as? WBWalletElement else
        {
            return
        }
        
        let walletVC = WBStoryboardFactory.storageStoryboard
            .instantiateViewController(withIdentifier: "drawerVC") as! WBStorageDetailViewController
        walletVC.modalTransitionStyle = .crossDissolve
        walletVC.modalPresentationStyle = .overCurrentContext
        walletVC.item = item
        UIApplication.shared.presentedViewControllers.last?.present(walletVC, animated: true, completion: nil)
    }
}
