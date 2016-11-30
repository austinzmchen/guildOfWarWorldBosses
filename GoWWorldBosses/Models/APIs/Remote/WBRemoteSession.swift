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
    var headers: [String:String] {get}
}

struct WBRemoteSession: WBRemoteSessionType {
    let domain: String
    let bearer: String
    
    var headers: [String:String] {
        get {
            var postHeaders: [String: String] = [:]
            postHeaders["Content-Type"] = "application/json"
            postHeaders["Authorization"] = "Bearer " + self.bearer
            return postHeaders
        }
    }
}
