//
//  WBStorageMainViewController.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-28.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit

class WBStorageMainViewController: UIViewController, WBDrawerItemViewControllerType {
    
    @IBAction func leftBarButtonTapped(_ sender: Any) {
        viewDelegate?.toggleDrawerView()
    }
    
    weak var viewDelegate: WBDrawerMasterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
