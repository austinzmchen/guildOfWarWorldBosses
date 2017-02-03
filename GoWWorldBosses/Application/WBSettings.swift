//
//  WBSettings.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2017-02-02.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation

class WBSettings {
    
    static var isDebugEnabled: Bool {
        let bool = false
        #if DEBUG
            bool = true
        #endif
        return bool
    }
}
