//
//  WBStoragePageViewController.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-28.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit

protocol WBStoragePageViewControllerDelegate: class {
    
    /**
     Called when the number of pages is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter count: the total number of pages.
     */
    func didUpdate(pageCount: Int, viewController: WBStoragePageViewController)
    
    /**
     Called when the current index is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter index: the index of the currently visible page.
     */
    func didUpdate(pageIndex: Int, viewController: WBStoragePageViewController)
    
}

class WBStoragePageViewController: UIPageViewController {

    weak var wbDelegate: WBStoragePageViewControllerDelegate?
    
    fileprivate(set) lazy var orderedViewControllers: [UIViewController] = {
        // The view controllers will be shown in this order
        let walletTableVC = WBStoryboardFactory.storageStoryboard
            .instantiateViewController(withIdentifier: "storageWalletTableVC") as! WBStorageWalletTableViewController
        walletTableVC.viewModel = WBStorageWalletViewModel()
        
        let bankTableVC = WBStoryboardFactory.storageStoryboard
            .instantiateViewController(withIdentifier: "storageBankTableVC") as! WBStorageBankTableViewController
        bankTableVC.viewModel = WBStorageBankViewModel()
        
        let materialsTableVC = WBStoryboardFactory.storageStoryboard
            .instantiateViewController(withIdentifier: "storageMaterialTableVC") as! WBStorageMaterialTableViewController
        materialsTableVC.viewModel = WBStorageMaterialViewModel()
        
        return [walletTableVC, bankTableVC, materialsTableVC]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let initialViewController = orderedViewControllers.first {
            scrollToViewController(initialViewController)
        }
        wbDelegate?.didUpdate(pageCount: orderedViewControllers.count, viewController: self)
    }
    
    func pageIndex() -> Int {
        if let firstViewController = viewControllers?.first,
            let index = orderedViewControllers.index(of: firstViewController)
        {
            return index
        } else {
            return -1
        }
    }
    
    /**
     Scrolls to the next view controller.
     */
    func scrollToNextViewController() {
        if let visibleViewController = viewControllers?.first,
            let nextViewController = pageViewController(self,
                                                        viewControllerAfter: visibleViewController) {
            scrollToViewController(nextViewController)
        }
    }
    
    /**
     Scrolls to the view controller at the given index. Automatically calculates
     the direction.
     
     - parameter newIndex: the new index to scroll to
     */
    func scrollToViewController(index newIndex: Int) {
        if let firstViewController = viewControllers?.first,
            let currentIndex = orderedViewControllers.index(of: firstViewController) {
            let direction: UIPageViewControllerNavigationDirection = newIndex >= currentIndex ? .forward : .reverse
            let nextViewController = orderedViewControllers[newIndex]
            scrollToViewController(nextViewController, direction: direction)
        }
    }
    
    fileprivate func newColoredViewController(_ color: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "\(color)ViewController")
    }
    
    /**
     Scrolls to the given 'viewController' page.
     
     - parameter viewController: the view controller to show.
     */
    fileprivate func scrollToViewController(_ viewController: UIViewController,
                                            direction: UIPageViewControllerNavigationDirection = .forward) {
        setViewControllers([viewController],
                           direction: direction,
                           animated: true,
                           completion: { (finished) -> Void in
                            // Setting the view controller programmatically does not fire
                            // any delegate methods, so we have to manually notify the
                            // 'tutorialDelegate' of the new index.
                            self.notifyDelegateOfNewIndex()
        })
    }
    
    /**
     Notifies '_tutorialDelegate' that the current page index was updated.
     */
    fileprivate func notifyDelegateOfNewIndex() {
        if let firstViewController = viewControllers?.first,
            let index = orderedViewControllers.index(of: firstViewController) {
            wbDelegate?.didUpdate(pageIndex: index, viewController: self)
        }
    }
    
}

// MARK: UIPageViewControllerDataSource

extension WBStoragePageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
}

extension WBStoragePageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool)
    {
        self.notifyDelegateOfNewIndex()
    }
    
}
