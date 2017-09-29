//
//  ACCustomPageViewController+CardTransitions.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-10.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit
import RZTransitions

struct ACCardInteraction {
    var inProgress: Bool
    var direction: ACCardScrollDirection
}
enum ACCardScrollDirection {
    case scrollLeft
    case scrollRight
}

extension ACCustomPageViewController {
    func configureCard(forViewController vc: UIViewController) {
        vc.transitioningDelegate = RZTransitionsManager.shared()
//        vc.cardDelegate = self // control cardVC delegate callbacks
        
        let ic = RZHorizontalInteractionController()
        ic.interactionDelegate = self
        ic.nextViewControllerDelegate = self
        ic.attach(vc, with: .pushPop)
        RZTransitionsManager.shared().setInteractionController(ic, fromViewController: type(of: vc), toViewController: nil, for: .pushPop)
        
        RZTransitionsManager.shared().setAnimationController(RZCardSlideAnimationController(), fromViewController: type(of: vc), for: .pushPop)
    }
}

// push card 0, 2, 1
extension ACCustomPageViewController: STTabsHeaderViewDelegate {
    func didSelectTab(atIndex idx: Int, animated: Bool) {
        guard var vcs = self.embedNavVC?.viewControllers
            else { return }
        
        vcs.removeLast() // ignore current vc
        let vc = self.cardViewControllers[idx] // target vc
        
        if let idx = vcs.index(of: vc) { // compare by instance id
            // if found
            let popToVC = vcs[idx]
            self.embedNavVC?.popToViewController(popToVC, animated: true)
        } else {
            // if not found
            guard let currentVC = self.embedNavVC?.viewControllers.last as? UIViewController,
                let currentVCIndex = self.cardViewControllers.index(of: currentVC)
                else { return }
            
            if idx > currentVCIndex {
                let pushVCs = self.cardViewControllers[0...idx]
                self.configureCard(forViewController: vc)
                self.embedNavVC?.setViewControllers(Array(pushVCs), animated: animated)
                
            } else if idx < currentVCIndex {
                if var newVCs = self.embedNavVC?.viewControllers {
                    if idx >= 0 && idx < newVCs.count {
                        newVCs.insert(vc, at: idx)
                        self.embedNavVC?.viewControllers = newVCs
                        self.embedNavVC?.popToViewController(vc, animated: animated)
                    }
                }
            } else {
                print("should not reach here")
            }
        }
    }
}

extension ACCustomPageViewController: RZBaseSwipeInteractionControllerDelegate {
    func interactionStart(_ push: Bool, withUnhandledSwipe isUnhandled: Bool) {
        guard !isUnhandled else {
            return
        }
    
        cardInteraction.inProgress = true
        cardInteraction.direction = push ? .scrollLeft : .scrollRight
    }
    
    func updateProgress(_ percent: CGFloat) {
        if cardInteraction.inProgress,
            let cellWidth = self.tabsHeaderView?.cellWidth
        {
            let x = cellWidth * percent
            self.tabsHeaderView?.setTabs(deltaOffsetX: x, direction: cardInteraction.direction)
        }
    }
    
    func interactionEnd(_ cancel: Bool) {
        defer {
            cardInteraction.inProgress = false
        }
        
        guard cardInteraction.inProgress,
            let tabMinX = self.tabsHeaderView?.tabMinX
            else { return }
        
        if cancel { // current card goes back to state 0
            self.tabsHeaderView?.animateTabOffsetX(tabMinX)
        } else {
            self.tabsHeaderView?.animateScroll(direction: cardInteraction.direction)
        }
    }
}

extension ACCustomPageViewController: RZTransitionInteractionControllerDelegate {
    
    func nextViewController(forInteractor interactor: RZTransitionInteractionController!) -> UIViewController! {
        guard let count = embedNavVC?.viewControllers.count,
            count > 0 else {
                return nil
        }
        
        currentCardIdx = count - 1
        let nextIdx = currentCardIdx + 1
        if nextIdx < cardViewControllers.count {
            return cardViewControllers[nextIdx]
        } else {
            return nil
        }
    }
}

// implement UINavigationControllerDelegate to let next VC be configured when nexrt VC is about to be showed, not eailer. Or interaction will break
extension ACCustomPageViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {}
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if let vc = viewController as? UIViewController {
            self.configureCard(forViewController: vc)
            
            // update nav bar title 
        }
    }
}

