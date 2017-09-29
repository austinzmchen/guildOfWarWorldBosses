//
//  STCardViewController.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-18.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

protocol STHeaderCollapseOptionType {
    var order: Float {get}
}

enum STHeaderTabCollapseOption: STHeaderCollapseOptionType {
    case normal
    case full
}

enum STHeaderCollapseOption: STHeaderCollapseOptionType {
    case none
    case collaspeTabBar(STHeaderTabCollapseOption)
    case collaspeAll
}

extension STHeaderCollapseOption {
    var order: Float {
        switch self {
        case .none:
            return 0
        case .collaspeTabBar(let n):
            return n.order
        case .collaspeAll:
            return 2
        }
    }
}

extension STHeaderTabCollapseOption {
    var order: Float {
        switch self {
        case .normal:
            return 1.1
        case .full:
            return 1.2
        }
    }
}

protocol STCardViewControllerDelegate: class {
}

protocol STCardViewControllerProtocol {
    weak var cardDelegate: STCardViewControllerDelegate? {get set}
    func requiresTabsHeader() -> Bool
}

extension STCardViewControllerProtocol {
    func requiresTabsHeader() -> Bool {
        return true
    }
}

struct STCustomNavBarItem {
    var backgroundColor: UIColor?
    var title: String?
    var isBackButtonHidden = true
    var isRightBarButtonHidden = false
}

//class STCardViewController: UIViewController, STCardViewControllerProtocol {
//    weak var cardDelegate: STCardViewControllerDelegate?
//    var collectionId: Int64?
//    var customNavBarItem: STCustomNavBarItem?
//    
//    func requiresTabsHeader() -> Bool {
//        return true
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        if customNavBarItem == nil {
//             /* UIColor(red: 0, green: 136/255.0, blue: 255/255.0, alpha: 0.8) */
//            customNavBarItem = STCustomNavBarItem(backgroundColor: UIColor.black,
//                                                  title: self.title, isBackButtonHidden: true,
//                                                  isRightBarButtonHidden: true)
//        }
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
//    
//    override var shouldAutorotate: Bool {
//        return false
//    }
//    
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { // default orientation options
//        return [.portrait]
//    }
//}
