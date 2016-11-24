//
//  WBRemoteSession.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-23.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation

protocol WBRemoteSessionType {
    var domain: String {get}
}

class WBRemoteSession: WBRemoteSessionType {
    let domain: String
  
    init(domain: String) {
        self.domain = domain
    }
}
