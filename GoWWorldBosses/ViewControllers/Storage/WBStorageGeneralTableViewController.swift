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
    @IBAction func unwindActionFromItemDetail(unwindSegue: UIStoryboardSegue) {}
    
    var viewModel: WBStorageTableViewModelType? {
        didSet {
            viewModel?.delegate = self
        }
    }
    
    let apiErrorView = WBApiErrorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up api Error view
        self.view.addSubview(self.apiErrorView)
        self.apiErrorView.isHidden = true
        
        var f = self.apiErrorView.frame
        f = self.view.bounds
        self.apiErrorView.frame = f
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushFromStorageTableVCToDetailVC",
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell),
            let items = self.viewModel?.items
        {
            if let vc = segue.destination as? WBStorageDetailViewController {
                vc.item = items[indexPath.row]
            } else if let vc = segue.destination as? WBStorageMaterialDetailViewController {
                vc.item = items[indexPath.row]
            } else if let vc = segue.destination as? WBStorageWalletDetailViewController {
                vc.item = items[indexPath.row]
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.items?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.viewModel!.identifierForSuitableCell(atIndex: indexPath.row),
                                                 for: indexPath) as! WBStorageItemTableViewCell
        
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

extension WBStorageGeneralTableViewController: WBStorageTableViewModelDelegate {
    func didComplete(success: Bool, items: [Any]?, error: Error?) {
        guard let e = error as? WBRemoteError else {
            return
        }
        
        switch e {
        case .scopePermissionDenied:
            self.apiErrorView.isHidden = false
        default:
            self.apiErrorView.isHidden = true
        }
    }
}
