//
//  WBAboutViewController.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-09-13.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit

class WBAboutViewController: UIViewController {

    @IBAction func backButtonTapped(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func doneButtonTapped(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
