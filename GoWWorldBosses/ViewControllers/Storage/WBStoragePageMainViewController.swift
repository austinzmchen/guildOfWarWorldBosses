//
//  WBStoragePageMainViewController.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2017-09-28.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

class WBStoragePageMainViewController: ACCustomPageViewController {
    
    required init?(coder aDecoder: NSCoder) { // this method is invoked before application:didFinishLaunchingWithOptions
        super.init(coder: aDecoder)
        
        let walletTableVC = WBStoryboardFactory.storageStoryboard.instantiateViewController(withIdentifier: "storageWalletTableVC") as! WBStorageWalletTableViewController
        walletTableVC.viewModel = WBStorageWalletViewModel()
//        vc1.view.backgroundColor = UIColor.blue
        
        let bankTableVC = WBStoryboardFactory.storageStoryboard.instantiateViewController(withIdentifier: "storageBankTableVC") as! WBStorageBankTableViewController
        bankTableVC.viewModel = WBStorageBankViewModel()
//        vc2.view.backgroundColor = UIColor.green
        
        let materialsTableVC = WBStoryboardFactory.storageStoryboard.instantiateViewController(withIdentifier: "storageMaterialTableVC") as! WBStorageMaterialTableViewController
        materialsTableVC.viewModel = WBStorageMaterialViewModel()
//        vc3.view.backgroundColor = UIColor.yellow
        
        let vcs:[UIViewController] = [walletTableVC, bankTableVC, materialsTableVC]
        
        cardViewControllers = vcs
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabsHeaderView?.tabTitles = ["Wallet", "Bank", "Materials"]
        tabsHeaderView?.style = .centerTab
    }
}
