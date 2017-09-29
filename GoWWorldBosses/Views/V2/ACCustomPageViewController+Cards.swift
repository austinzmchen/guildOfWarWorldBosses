//
//  ACCustomPageViewController+Cards.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-27.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

extension ACCustomPageViewController {
    
    func collaspeHeader(option: STHeaderCollapseOption, animated: Bool, completion: ((Bool) -> ())? = nil) {
        guard option.order != currentCollapseOption.order
            else { return } // ignore redundant state
        
        self.currentCollapseOption = option
        
        switch option {
        case .none:
            // self.customNavBarViewTop.constant = 0
            // self.tabsHeaderViewTop.constant = 54
            break
        case .collaspeTabBar(let tabCollapseOption):
            // self.customNavBarViewTop.constant = 0
            
            /*
             switch tabCollapseOption {
             case .normal:
             self.tabsHeaderViewTop.constant = 14
             case .full:
             self.tabsHeaderViewTop.constant = self.tabsHeaderView.bounds.height * -1
             }
             */
            break
        case .collaspeAll:
            // self.customNavBarViewTop.constant = self.customNavBarView.bounds.height * -1
            // self.tabsHeaderViewTop.constant = self.tabsHeaderView.bounds.height * -1
            break
        }
        
        guard animated else {
            self.tabsHeaderView?.superview?.layoutIfNeeded()
            if let c = completion { c(true) }
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.tabsHeaderView?.superview?.layoutIfNeeded()
        }, completion: { (finished) in
            self.tabsHeaderView?.superview?.layoutIfNeeded()
            if let c = completion { c(finished) }
        })
    }
}

extension ACCustomPageViewController: STCardViewControllerDelegate {

}

