//
//  WBAboutViewController.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-09-13.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit
import Crashlytics

class WBAboutViewController: UIViewController {

    @IBAction func backButtonTapped(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func doneButtonTapped(_ sender: AnyObject) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func debug_forceCrashButtonTapped(_ sender: Any) {
        // Crashlytics.sharedInstance().crash()
        Crashlytics.sharedInstance().throwException()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
