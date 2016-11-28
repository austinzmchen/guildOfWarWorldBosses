//
//  WBStoryboardFactory.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-28.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit

class WBStoryboardFactory: NSObject {
    
    static var drawerStoryboard: UIStoryboard {
        return UIStoryboard(name: "Drawer", bundle: nil)
    }
    
    static var timerStoryboard: UIStoryboard {
        return UIStoryboard(name: "Timer", bundle: nil)
    }
    
    static var storageStoryboard: UIStoryboard {
        return UIStoryboard(name: "Storage", bundle: nil)
    }
}
