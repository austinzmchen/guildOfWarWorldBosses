//
//  WBMainViewController.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2017-09-27.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

class WBMainViewController: UIViewController {
    
    @IBOutlet weak var embeddedView: UIView!
    
    var currentPageVC: UIViewController?
    
    @IBAction func timerTabButtonTapped(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "timerPageVC")
        switchPageTo(viewController: vc)
    }
    
    @IBAction func storageTabButtonTapped(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "storagePageVC")
        switchPageTo(viewController: vc)
    }
    
    @IBAction func characterTabButtonTapped(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "charactersPageVC")
        switchPageTo(viewController: vc)
    }
    
    @IBAction func moreTabButtonTapped(_ sender: Any) {
        let settingsNavVC = WBStoryboardFactory.settingsStoryboard.instantiateViewController(withIdentifier: "settingsNavVC")
        self.present(settingsNavVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embeddedVCSegue" {
            // default load timerVC
        }
    }
    
    func switchPageTo(viewController: UIViewController) {
        let prevPageVC = currentPageVC
        prevPageVC?.willMove(toParentViewController: nil)
        
        let vc = viewController
        addChildViewController(vc)
        embeddedView.translatesAutoresizingMaskIntoConstraints = false
        embeddedView.addSubview(vc.view)
        
        NSLayoutConstraint.activate([
            vc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            vc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            vc.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            vc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            ])
        
        vc.didMove(toParentViewController: self)
        
        prevPageVC?.view.removeFromSuperview()
        prevPageVC?.removeFromParentViewController()
        
        currentPageVC = vc
    }
}
