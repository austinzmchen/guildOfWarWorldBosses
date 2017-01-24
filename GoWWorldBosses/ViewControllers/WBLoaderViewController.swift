//
//  WBLoaderViewController.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-04.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit

enum WBLoaderStatus {
    case loading
    case loaded
}

class WBLoaderViewController: UIViewController {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var spinner: UIImageView!
    
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
        //loadingIndicator.startAnimating()
        
        self.resetLoader()
    }
    
    deinit {
        //loadingIndicator.stopAnimating()
        
        self.status = .loaded
    }

    // MARK: instance methods
    
    var status: WBLoaderStatus = .loading
    
    @objc fileprivate func startLoader() {
        switch self.status {
        case .loading:
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveLinear, animations: { [weak self] in
                if let iv = self?.spinner {
                    iv.transform = iv.transform.rotated(by: -CGFloat(M_PI_2))
                }
            }) { [weak self] (finished) -> () in
                _ = self?.perform(#selector(self?.startLoader))
            }
            break
        default:
            break
        }
    }
    
    func resetLoader() {
        self.status = .loading
        self.startLoader()
    }
}
