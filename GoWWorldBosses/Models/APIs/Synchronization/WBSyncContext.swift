//
//  WBSyncContext.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-29.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import RealmSwift

enum WBSyncPendingTaskPriority: Int {
    case low = 0, medium, high
}

class WBSyncPendingTask: NSObject {
    var taskPriority: WBSyncPendingTaskPriority = .low
    var taskAction: String = ""
}

class WBSyncContext: NSObject {
    // remote context
    var remoteSession: WBRemoteSession?
    
    // a list of to-do items
    var pendingTasks: [WBSyncPendingTask] = []
}

// serializing HAPSyncContext
extension WBSyncContext {
    convenience init (remoteSession: WBRemoteSession?) {
        self.init()
        self.remoteSession = remoteSession
    }
    
    convenience init?(coder decoder: NSCoder) {
        self.init()
        if let pt = decoder.decodeObject(forKey: "pendingTasks") as? [WBSyncPendingTask] {
            self.pendingTasks = pt
        }
    }
    
    func encodeWithCoder(_ coder: NSCoder) {
        coder.encode(self.pendingTasks, forKey: "pendingTasks")
    }
}
