//
//  WBStoryboardFactory.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-28.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit

class WBStoryboardFactory: NSObject {
    
    static func storyboard(byFileName fileName: String) -> UIStoryboard? {
        return UIStoryboard(name: fileName, bundle: nil)
    }
    
    static var apiKeyEntryStoryboard: UIStoryboard {
        return UIStoryboard(name: "APIKeyEntry", bundle: nil)
    }
    
    static var drawerStoryboard: UIStoryboard {
        return UIStoryboard(name: "Drawer", bundle: nil)
    }
    
    static var timerStoryboard: UIStoryboard {
        return UIStoryboard(name: "Timer", bundle: nil)
    }
    
    static var charactersStoryboard: UIStoryboard {
        return UIStoryboard(name: "Characters", bundle: nil)
    }
    
    static var storageStoryboard: UIStoryboard {
        return UIStoryboard(name: "Storage", bundle: nil)
    }
    
    static var settingsStoryboard: UIStoryboard {
        return UIStoryboard(name: "Settings", bundle: nil)
    }
    
    static var utilityStoryboard: UIStoryboard {
        return UIStoryboard(name: "Utility", bundle: nil)
    }
}
