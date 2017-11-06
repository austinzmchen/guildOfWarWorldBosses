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
    
    @IBOutlet weak var timerTabButton: UIButton!
    @IBOutlet weak var storageTabButton: UIButton!
    @IBOutlet weak var characterTabButton: UIButton!
    @IBOutlet weak var moreTabButton: UIButton!
    
    var currentSelectedTabIdx: Int = 0
    var tabButtons: [UIButton] = []
    
    @IBAction func timerTabButtonTapped(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "timerPageVC")
        switchPageTo(viewController: vc)
        selectTab(idx: 0)
    }
    
    @IBAction func storageTabButtonTapped(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "storagePageVC")
        switchPageTo(viewController: vc)
        selectTab(idx: 1)
    }
    
    @IBAction func characterTabButtonTapped(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "charactersPageVC")
        switchPageTo(viewController: vc)
        selectTab(idx: 2)
    }
    
    @IBAction func moreTabButtonTapped(_ sender: Any) {
        let settingsNavVC = WBStoryboardFactory.settingsStoryboard.instantiateViewController(withIdentifier: "settingsNavVC")
        self.present(settingsNavVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabButtons = [timerTabButton, storageTabButton, characterTabButton, moreTabButton]
        
        timerTabButton.setImage(UIImage(named: "icTimers"), for: .normal)
        timerTabButton.setImage(UIImage(named: "icTimersOn"), for: .selected)
        timerTabButton.isSelected = true
        
        storageTabButton.setImage(UIImage(named: "icStorage"), for: .normal)
        storageTabButton.setImage(UIImage(named: "icStorageOn"), for: .selected)
        storageTabButton.isSelected = false
        
        characterTabButton.setImage(UIImage(named: "icCharacters"), for: .normal)
        characterTabButton.setImage(UIImage(named: "icCharactersOn"), for: .selected)
        characterTabButton.isSelected = false
        
        moreTabButton.setImage(UIImage(named: "icMore"), for: .normal)
        moreTabButton.setImage(UIImage(named: "icMoreOn"), for: .selected)
        moreTabButton.isSelected = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embeddedVCSegue" {
            // default load timerVC
        }
    }
    
    func selectTab(idx: Int) {
        let previous = currentSelectedTabIdx
        currentSelectedTabIdx = idx
        
        tabButtons[previous].isSelected = false
        tabButtons[currentSelectedTabIdx].isSelected = true
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

fileprivate var kTabNormalImgs: [String] = ["icTimersOff", "icStorageOff", "icCharactersOff", "icMoreOff"]
fileprivate var kTabHighlightImgs: [String] = ["icTimers", "icStorage", "icCharacters", "icMore"]
