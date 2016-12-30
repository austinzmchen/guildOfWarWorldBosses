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
    let apiErrorView = WBApiErrorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.apiErrorView)
        
        var f = self.apiErrorView.frame
        f = self.view.bounds
        self.apiErrorView.frame = f
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.itemsCount() ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = self.viewModel!.identifierForSuitableCell(atIndex: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WBStorageItemTableViewCell
        
        if let c = cell as? WBStorageWalletCoinTableViewCell,
            let vm = self.viewModel as? WBStorageWalletViewModel
        {
           let coinValue = vm.coinValueForItem(atIndex: indexPath.row)
            c.goldLabel.text = String(format: "%d", coinValue / 10000 )
            c.silverLabel.text = String(format: "%d", (coinValue / 100) % 100 )
            c.bronzeLabel.text = String(format: "%d", coinValue % 100)
        } else {
            // Configure the cell...
            cell.mainTitleLabel.text = self.viewModel?.mainTitleForItem(atIndex: indexPath.row)
            cell.subTitleLabel.text = self.viewModel?.subTitleForItem(atIndex: indexPath.row)
            if let imageUrlString = self.viewModel?.imageUrlStringForItem(atIndex: indexPath.row) {
                cell.leftImageView.sd_setImage(with: URL(string: imageUrlString))
            }
        }
        
        if (indexPath.row % 2) > 0 {
            // odd number
            cell.contentView.backgroundColor = UIColor(red: 10/255.0, green: 10/255.0, blue: 10/255.0, alpha: 1)
        } else {
            // even number
            cell.contentView.backgroundColor = UIColor.black
        }
        
        return cell
    }

}
