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
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
        guard self.storagePageVC?.pageIndex() != sender.selectedSegmentIndex else {
            return
        }
        
        self.storagePageVC?.scrollToViewController(index: sender.selectedSegmentIndex)
//        switch sender.selectedSegmentIndex {
//        case 0:
//            self.storagePageVC?.scrollToViewController(index: 0)
//            break
//        case 1:
//            break
//        default:
//            break
//        }
    }
    
    weak var viewDelegate: WBDrawerMasterViewControllerDelegate?
    var storagePageVC: WBStoragePageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let leftBarButtonItem = UIBarButtonItem.barButtonItem(withImageName:"icBurger",
                                                              title: "Storage",
                                                              forTarget: self,
                                                              action: #selector(leftBarButtonTapped(_:)) )
        self.navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "containedStorageVCSegue" {
            self.storagePageVC = segue.destination as! WBStoragePageViewController
            self.storagePageVC?.wbDelegate = self
        }
    }
}

extension WBStorageMainViewController: WBStoragePageViewControllerDelegate {
    
    func didUpdate(pageIndex: Int, viewController: WBStoragePageViewController) {
        self.segmentControl.selectedSegmentIndex = pageIndex
    }

    func didUpdate(pageCount: Int, viewController: WBStoragePageViewController) {
    }
    

}
