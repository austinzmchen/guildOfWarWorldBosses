//
//  WBStorageWalletTableViewController.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2017-03-03.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

class WBStorageWalletTableViewController: WBStorageGeneralTableViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! WBStorageItemTableViewCell
        
        guard let items = self.viewModel?.items, indexPath.row < items.count,
            let item = items[indexPath.row] as? WBWalletElement else {
            return cell
        }
        
        
        if let c = cell as? WBStorageWalletCoinTableViewCell,
            let vm = self.viewModel as? WBStorageWalletViewModel
        {
            let coinValue = vm.coinValueForItem(atIndex: indexPath.row)
            c.goldLabel.text = String(format: "%d", coinValue / 10000 )
            c.silverLabel.text = String(format: "%d", (coinValue / 100) % 100 )
            c.bronzeLabel.text = String(format: "%d", coinValue % 100)
        } else {
            // Configure the cell...
            cell.mainTitleLabel.text = item.currency?.name
            cell.subTitleLabel.text = String(format: "%d", item.value)
            if let imageUrlString = item.currency?.icon {
                cell.leftImageView.sd_setImage(with: URL(string: imageUrlString))
            }
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
            .instantiateViewController(withIdentifier: "drawerWalletDetailVC") as! WBStorageWalletDetailViewController
        walletVC.modalTransitionStyle = .crossDissolve
        walletVC.modalPresentationStyle = .overCurrentContext
        walletVC.item = item
        UIApplication.shared.presentedViewControllers.last?.present(walletVC, animated: true, completion: nil)
    }
}
