//
//  WBLoaderViewController.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-04.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit

class WBLoaderViewController: UIViewController {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    static var sharedInstance: WBLoaderViewController? = nil
    
    static func instantiate() -> WBLoaderViewController {
        let loaderVC = WBStoryboardFactory.utilityStoryboard.instantiateViewController(withIdentifier: "loaderVC") as! WBLoaderViewController
        loaderVC.modalTransitionStyle = .crossDissolve
        loaderVC.modalPresentationStyle = .overCurrentContext
        return loaderVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadingIndicator.startAnimating()
    }
    
    deinit {
        loadingIndicator.stopAnimating()
    }

}
